import os
import hashlib
import sys

def pausar():
    input("\nPressione ENTER para continuar...")

def hash_arquivo(caminho, bloco=1024*1024):
    h = hashlib.sha1()
    try:
        with open(caminho, "rb") as f:
            while True:
                dados = f.read(bloco)
                if not dados:
                    break
                h.update(dados)
        return h.hexdigest()
    except:
        return None

def escanear(pasta):
    print("\n🔍 Escaneando arquivos (pode demorar)...")
    arquivos = {}
    for raiz, _, files in os.walk(pasta):
        for nome in files:
            caminho = os.path.join(raiz, nome)
            h = hash_arquivo(caminho)
            if not h:
                continue
            arquivos.setdefault(h, []).append(caminho)
    return {h: v for h, v in arquivos.items() if len(v) > 1}

def escolher_pastas():
    print("\n📂 Pasta RAIZ para escanear (ENTER = pasta atual):")
    raiz = input("> ").strip()
    if not raiz:
        raiz = os.getcwd()

    print("\n📂 Pasta RUIM (ENTER = nenhuma):")
    ruim = input("> ").strip()

    raiz = os.path.abspath(raiz)
    ruim = os.path.abspath(ruim) if ruim else None

    return raiz, ruim

def esta_na_pasta_ruim(caminho, pasta_ruim):
    if not pasta_ruim:
        return False
    caminho = os.path.abspath(caminho)
    return caminho.startswith(pasta_ruim)

def mais_recente(lista):
    return max(lista, key=lambda x: os.path.getmtime(x))

def listar(duplicados):
    if not duplicados:
        print("\n✅ Nenhum duplicado encontrado.")
        return

    print(f"\n🔁 {len(duplicados)} grupos de duplicados encontrados:\n")
    for i, arquivos in enumerate(duplicados.values(), 1):
        print(f"Grupo {i}:")
        for a in arquivos:
            print(" ", a)
        print()

def plano_limpeza(duplicados, pasta_ruim):
    apagar = []
    manter = []

    for arquivos in duplicados.values():
        fora_ruim = [a for a in arquivos if not esta_na_pasta_ruim(a, pasta_ruim)]
        dentro_ruim = [a for a in arquivos if esta_na_pasta_ruim(a, pasta_ruim)]

        if fora_ruim:
            escolhido = mais_recente(fora_ruim)
        else:
            escolhido = mais_recente(arquivos)

        manter.append(escolhido)

        for a in arquivos:
            if a != escolhido:
                apagar.append(a)

    return manter, apagar

def limpar(apagar):
    if not apagar:
        print("\nNada para apagar.")
        return

    print("\n🗑️ Arquivos que SERÃO APAGADOS:\n")
    for a in apagar:
        print(" ", a)

    print(f"\n⚠️ Total: {len(apagar)} arquivos")

    conf = input("\nDigite 'SIM' para confirmar: ").strip().upper()
    if conf != "SIM":
        print("Cancelado.")
        return

    erros = 0
    for a in apagar:
        try:
            os.remove(a)
            print("[OK]", a)
        except Exception as e:
            print("[ERRO]", a, e)
            erros += 1

    print(f"\n✅ Concluído. Erros: {erros}")

def main():
    while True:
        print("\n======= LIMPEZA DE DUPLICADOS =======")
        print("1) Listar duplicados")
        print("2) Limpeza automática")
        print("3) Sair")

        op = input("\nEscolha: ").strip()

        if op == "3":
            print("Saindo...")
            return

        raiz, pasta_ruim = escolher_pastas()
        duplicados = escanear(raiz)

        if op == "1":
            listar(duplicados)
            pausar()

        elif op == "2":
            _, apagar = plano_limpeza(duplicados, pasta_ruim)
            limpar(apagar)
            pausar()

        else:
            print("Opção inválida.")
            pausar()

if __name__ == "__main__":
    main()
