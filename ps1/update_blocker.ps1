# =============================================
# Controle de Windows Update - Windows 10 22H2
# 15/01/2026
# Alfredo Assis
# =============================================

# ---- Verifica se está rodando como Administrador ----
$admin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")

if (-not $admin) {
    Write-Host "ERRO: Execute este script como ADMINISTRADOR!" -ForegroundColor Red
    Pause
    exit
}

function Exec {
    param($cmd)

    Write-Host ">> $cmd"
    cmd.exe /c $cmd
    if ($LASTEXITCODE -ne 0) {
        Write-Host "FALHA ao executar: $cmd" -ForegroundColor Red
        return $false
    }
    return $true
}

function Desativar-Update {
    Write-Host "Desativando Windows Update..." -ForegroundColor Yellow

    $fatal = $false

    Exec 'reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v NoAutoUpdate /t REG_DWORD /d 1 /f' | Out-Null
    Exec 'reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v DoNotConnectToWindowsUpdateInternetLocations /t REG_DWORD /d 1 /f' | Out-Null
    Exec 'reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v TargetReleaseVersion /t REG_DWORD /d 1 /f' | Out-Null
    Exec 'reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v TargetReleaseVersionInfo /t REG_SZ /d "22H2" /f' | Out-Null

    Write-Host "Tentando parar servicos (pode falhar, nao e critico)..."

    Exec 'sc.exe stop wuauserv' | Out-Null
    if (-not (Exec 'sc.exe config wuauserv start= disabled')) { $fatal = $true }

    Exec 'sc.exe stop UsoSvc' | Out-Null
    if (-not (Exec 'sc.exe config UsoSvc start= disabled')) { $fatal = $true }

    if ($fatal) {
        Write-Host "ERRO: Falha critica ao DESATIVAR Windows Update!" -ForegroundColor Red
    } else {
        Write-Host "SUCESSO: Windows Update BLOQUEADO corretamente." -ForegroundColor Green
    }
}


function Ativar-Update {
    Write-Host "Reativando Windows Update..." -ForegroundColor Yellow

    $ok = $true

    Exec 'reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v NoAutoUpdate /f'
    Exec 'reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v DoNotConnectToWindowsUpdateInternetLocations /f'
    Exec 'reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v TargetReleaseVersion /f'
    Exec 'reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v TargetReleaseVersionInfo /f'

    $ok = $ok -and (Exec 'sc.exe config wuauserv start= demand')
    $ok = $ok -and (Exec 'sc.exe start wuauserv')

    $ok = $ok -and (Exec 'sc.exe config UsoSvc start= demand')
    $ok = $ok -and (Exec 'sc.exe start UsoSvc')

    if ($ok) {
        Write-Host "SUCESSO: Windows Update foi REATIVADO." -ForegroundColor Green
    } else {
        Write-Host "ATENCAO: Houve FALHAS ao reativar o Windows Update!" -ForegroundColor Red
    }
}

function Mostrar-Status {
    Write-Host "Status atual:" -ForegroundColor Cyan

    Get-Service wuauserv, UsoSvc | Select Name, Status, StartType

    $reg = Get-ItemProperty "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -ErrorAction SilentlyContinue
    if ($reg -and $reg.NoAutoUpdate -eq 1) {
        Write-Host "Politica: BLOQUEADO via registro" -ForegroundColor Green
    } else {
        Write-Host "Politica: NAO bloqueado via registro" -ForegroundColor Yellow
    }
}

do {
    Clear-Host
    Write-Host "========================================="
    Write-Host " Controle de Windows Update (Win10 22H2) "
    Write-Host "========================================="
    Write-Host ""
    Write-Host "1 - Desativar Windows Update"
    Write-Host "2 - Ativar Windows Update"
    Write-Host "3 - Ver Status"
    Write-Host "0 - Sair"
    Write-Host ""

    $op = Read-Host "Escolha uma opcao"

    switch ($op) {
        "1" { Desativar-Update; Pause }
        "2" { Ativar-Update; Pause }
        "3" { Mostrar-Status; Pause }
        "0" { 
    Write-Host "Saindo..."
    exit }
}


} while ($true)
