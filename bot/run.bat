@echo off
title Archipelago Discord Bot
cd /d "%~dp0"

echo.
echo  ============================================
echo   Archipelago Discord Bot
echo  ============================================
echo.

:: Check Node.js is installed
where node >nul 2>&1
if %errorlevel% neq 0 (
    echo  [!] Node.js is not installed.
    echo.
    echo      Download and install it from https://nodejs.org/
    echo      Then run this file again.
    echo.
    pause
    exit /b 1
)

:: Check config file exists
if not exist "archipelago.conf" (
    echo  [!] archipelago.conf not found.
    echo.
    echo      It should be in the same folder as this file.
    echo.
    pause
    exit /b 1
)

:: Check config is filled in — if not, open it in Notepad and wait
:check_config
findstr /C:"FILL_ME_IN" archipelago.conf >nul 2>&1
if %errorlevel% equ 0 (
    echo  [!] archipelago.conf is not configured yet.
    echo.
    echo      Opening it for you now. Fill in the three values, save the file,
    echo      then press any key here to continue.
    echo.
    echo        CT_API_KEY        - from your CheeseTrackers profile page
    echo        DISCORD_TOKEN     - from discord.com/developers ^> your app ^> Bot
    echo        DISCORD_CLIENT_ID - from discord.com/developers ^> your app ^> General Information
    echo.
    start notepad archipelago.conf
    pause
    goto check_config
)

:: Install dependencies on first run
if not exist "node_modules" (
    echo  Installing dependencies ^(first run only^)...
    echo.
    npm install
    echo.
)

echo  Starting bot...
echo.
node index.js
echo.
echo  Bot has stopped. Check above for any errors.
pause
