import os
import sys

def pausar():
    input("\nPressione ENTER para continuar...")

def escolher_pasta():
    print("\n📂 Pasta para escanear (ENTER = pasta atual):")
    p = input("> ").strip()
    if not p:
        p = os.getcwd()
    return os.path.abspath(p)

def parece_mp3(caminho):
    return caminho.lower().endswith(".mp3")

def contar_mp3(pasta):
    total = 0
    for raiz, _, arquivos in os.walk(pasta):
        for nome in arquivos:
            if nome.lower().endswith(".mp3"):
                total += 1
    return total

def verificar_mp3(caminho):
    """
    Verificação heurística:
    - Tenta ler o arquivo inteiro
    - Verifica se tem tamanho mínimo
    - Procura headers MP3
    """
    try:
        tamanho = os.path.getsize(caminho)
        if tamanho < 1024:  # pequeno demais pra ser MP3 válido
            return False

        with open(caminho, "rb") as f:
            data = f.read()

        # Verificar header ID3 ou frame sync
        if data[:3] == b"ID3":
            return True

        # Procurar frame sync 0xFF 0xFB ou similares
        encontrou_sync = False
        for i in range(0, min(len(data) - 1, 1024 * 1024)):  # procura só no primeiro 1MB
            if data[i] == 0xFF and (data[i+1] & 0xE0) == 0xE0:
                encontrou_sync = True
                break

        if not encontrou_sync:
            return False

        return True

    except:
        return False

def escanear(pasta):
    corrompidos = []
    total = contar_mp3(pasta)
    verificados = 0

    print(f"\n🔍 Total de MP3 encontrados: {total}")
    print("🔎 Iniciando verificação...\n")

    for raiz, _, arquivos in os.walk(pasta):
        for nome in arquivos:
            if not nome.lower().endswith(".mp3"):
                continue

            verificados += 1
            caminho = os.path.join(raiz, nome)

            # Progresso
            percent = (verificados / total) * 100 if total else 0
            print(f"\r[{verificados} / {total}] {percent:.2f}% - {caminho[:80]}", end="")

            ok = verificar_mp3(caminho)
            if not ok:
                print(f"\n[CORROMPIDO] {caminho}")
                corrompidos.append(caminho)

    print(f"\n\n🎵 Total de MP3 verificados: {verificados}")
    print(f"💥 Corrompidos encontrados: {len(corrompidos)}")

    return corrompidos

def mostrar_lista(lista):
    if not lista:
        print("\n✅ Nenhum arquivo corrompido encontrado.")
        return

    print("\n======= LISTA FINAL DE ARQUIVOS CORROMPIDOS =======\n")
    for a in lista:
        print(" ", a)

    print(f"\n⚠️ Total: {len(lista)} arquivos")

def salvar_log(lista, arquivo="corrompidos.txt"):
    with open(arquivo, "w", encoding="utf-8") as f:
        if not lista:
            f.write("Nenhum arquivo corrompido encontrado.\n")
        else:
            f.write("ARQUIVOS CORROMPIDOS:\n\n")
            for a in lista:
                f.write(a + "\n")
    print(f"\n📄 Log salvo em: {arquivo}")

def apagar(lista):
    if not lista:
        print("\nNada para apagar.")
        return

    print("\n🗑️ Arquivos que SERÃO APAGADOS:\n")
    for a in lista:
        print(" ", a)

    print(f"\n⚠️ Total: {len(lista)} arquivos")

    conf = input("\nDigite 'SIM' para confirmar: ").strip().upper()
    if conf != "SIM":
        print("Cancelado.")
        return

    erros = 0
    for a in lista:
        try:
            os.remove(a)
            print("[OK]", a)
        except Exception as e:
            print("[ERRO]", a, e)
            erros += 1

    print(f"\n✅ Concluído. Erros: {erros}")

def main():
    while True:
        print("\n======= VERIFICADOR DE MP3 CORROMPIDOS =======")
        print("1) Verificar e listar")
        print("2) Verificar e apagar")
        print("3) Sair")

        op = input("\nEscolha: ").strip()

        if op == "3":
            print("Saindo...")
            return

        pasta = escolher_pasta()
        corrompidos = escanear(pasta)
        salvar_log(corrompidos)

        if op == "1":
            pausar()

        elif op == "2":
            apagar(corrompidos)
            pausar()

        else:
            print("Opção inválida.")
            pausar()

if __name__ == "__main__":
    main()
