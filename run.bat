@echo off
REM ═══════════════════════════════════════════════════════════════════════════
REM  Hotel ERP Management System  –  One-click Build & Run (Windows)
REM  Double-click this file from File Explorer to compile and launch.
REM ═══════════════════════════════════════════════════════════════════════════
title Hotel ERP – Launcher

setlocal

REM Change to the folder that contains this script
cd /d "%~dp0"

set SRC_DIR=src
set OUT_DIR=out
set LIB_DIR=lib
set MAIN_CLASS=Main

REM ── 1. Find Java (javac / java) ──────────────────────────────────────────
REM Try system PATH first
set JAVA_BIN=
where javac >nul 2>&1
if not errorlevel 1 (
    set JAVA_BIN=
    goto :found_java
)

REM Fall back to known install locations
for %%D in (
    "C:\Program Files\Eclipse Adoptium\jdk-25.0.3.9-hotspot\bin"
    "C:\Program Files\Eclipse Adoptium\jdk-21.0.5.11-hotspot\bin"
    "C:\Program Files\Java\jdk-21\bin"
    "C:\Program Files\Java\jdk-17\bin"
    "C:\Program Files\Microsoft\jdk-21.0.5.11-hotspot\bin"
) do (
    if exist "%%~D\javac.exe" (
        set "JAVA_BIN=%%~D\"
        echo  [INFO]  Found JDK at: %%~D
        goto :found_java
    )
)

echo.
echo  [ERROR] Java JDK not found on this machine.
echo.
echo  Please install JDK 17 or later from:
echo    https://adoptium.net
echo  Then re-run this script.
echo.
pause
exit /b 1

:found_java

REM ── 2. Find SQLite JDBC jar ──────────────────────────────────────────────
set SQLITE_JAR=
for %%f in (%LIB_DIR%\sqlite-jdbc-*.jar) do set SQLITE_JAR=%%f

if "%SQLITE_JAR%"=="" (
    echo.
    echo  [ERROR] sqlite-jdbc-*.jar not found in the lib\ folder.
    echo.
    pause
    exit /b 1
)
echo  [INFO]  Using driver: %SQLITE_JAR%

REM ── 3. Create output directory ───────────────────────────────────────────
if not exist "%OUT_DIR%" mkdir "%OUT_DIR%"

REM ── 4. Compile ───────────────────────────────────────────────────────────
echo  [INFO]  Compiling...
"%JAVA_BIN%javac" -cp "%SQLITE_JAR%" -d "%OUT_DIR%" %SRC_DIR%\*.java

if errorlevel 1 (
    echo.
    echo  [ERROR] Compilation failed – see errors above.
    echo.
    pause
    exit /b 1
)
echo  [INFO]  Compilation successful.

REM ── 5. Launch ────────────────────────────────────────────────────────────
echo  [INFO]  Launching Hotel ERP...
echo.
"%JAVA_BIN%java" -cp "%OUT_DIR%;%SQLITE_JAR%" %MAIN_CLASS%

endlocal
