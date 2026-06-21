@echo off
title Archipelago Discord Bot
cd /d "%~dp0"

echo.
echo  ============================================
echo   Archipelago Discord Bot
echo  ============================================
echo.

:: ── Node.js check ────────────────────────────────────────────────────────────
where node >nul 2>&1
if %errorlevel% neq 0 (
    echo  [!] Node.js not found. Installing...
    echo.

    :: Try winget via full path (Windows 10/11 — avoids PATH lookup issues)
    set "WINGET=%LOCALAPPDATA%\Microsoft\WindowsApps\winget.exe"
    if exist "%WINGET%" (
        "%WINGET%" install --id OpenJS.NodeJS.LTS --silent --accept-package-agreements --accept-source-agreements
        if %errorlevel% equ 0 (
            echo.
            echo  Node.js installed. Restarting...
            echo.
            start "" "%~f0"
            exit
        )
        echo.
        echo  [!] winget install failed, trying PowerShell download...
        echo.
    )

    :: Fallback: download and install LTS via PowerShell
    powershell -NoProfile -ExecutionPolicy Bypass -Command "[Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12; $v=((Invoke-WebRequest 'https://nodejs.org/dist/index.json' -UseBasicParsing).Content ^| ConvertFrom-Json ^| Where-Object{$_.lts -ne $false})[0].version; $d=$env:TEMP+'\node_setup.msi'; Write-Host ('  Downloading Node.js '+$v+'...'); (New-Object Net.WebClient).DownloadFile('https://nodejs.org/dist/'+$v+'/node-'+$v+'-x64.msi',$d); Write-Host '  Installing (a UAC prompt may appear)...'; Start-Process msiexec -ArgumentList @('/i',$d,'/quiet','/norestart') -Wait -Verb RunAs"
    if %errorlevel% neq 0 (
        echo.
        echo  [!] Automatic install failed.
        echo      Please install Node.js manually from https://nodejs.org/
        echo      Then run this file again.
        echo.
        pause
        exit /b 1
    )
    echo.
    echo  Node.js installed. Restarting...
    echo.
    start "" "%~f0"
    exit
)

:: ── Config check ──────────────────────────────────────────────────────────────
if not exist "archipelago.conf" (
    echo  [!] archipelago.conf not found.
    echo.
    echo      It should be in the same folder as this file.
    echo.
    pause
    exit /b 1
)

:check_config
findstr /C:"FILL_ME_IN" archipelago.conf >nul 2>&1
if %errorlevel% equ 0 (
    echo  [!] archipelago.conf is not configured yet.
    echo.
    echo      Opening it for you now. Fill in the two values, save the file,
    echo      then press any key here to continue.
    echo.
    echo        CT_API_KEY     - from your CheeseTrackers profile page
    echo        DISCORD_TOKEN  - from discord.com/developers ^> your app ^> Bot
    echo.
    start notepad archipelago.conf
    pause
    goto check_config
)

:: ── Dependencies ─────────────────────────────────────────────────────────────
if not exist "node_modules" (
    echo  Installing dependencies ^(first run only^)...
    echo.
    npm install
    echo.
)

:: ── Start ─────────────────────────────────────────────────────────────────────
echo  Starting bot...
echo.
node index.js
echo.
echo  Bot has stopped. Check above for any errors.
pause
