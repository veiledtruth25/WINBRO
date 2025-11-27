@echo off
setlocal enabledelayedexpansion

:: =====================================================
:: CEK ADMIN PRIVILEGES
:: =====================================================
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Script membutuhkan hak Administrator.
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

:: =====================================================
:: KONFIGURASI
:: =====================================================
set "DOWNLOAD_URL=https://veiledtruth25.github.io/WINBRO/INSTALLER/windsorbrokers15setup.exe"
set "DOWNLOAD_FILE=windsorbrokers15setup.exe"
set "ORIGINAL_FOLDER=C:\Program Files\Windsor Brokers MT5 Terminal"

echo ========================================
echo Windsor Brokers Auto Installer
echo ========================================
echo.


:: =====================================================
:: FUNGSI DETEKSI STARTUP FOLDER
:: =====================================================
set "ALL_USERS_STARTUP=C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup"
set "USER_STARTUP=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"

if exist "%USER_STARTUP%" (
    set "STARTUP_FOLDER=%USER_STARTUP%"
) else (
    set "STARTUP_FOLDER=%ALL_USERS_STARTUP%"
)

echo Menggunakan Startup Folder:
echo %STARTUP_FOLDER%
echo.


:: =====================================================
:: CEK FOLDER INSTALASI
:: =====================================================
echo Mengecek folder instalasi utama...

if exist "%ORIGINAL_FOLDER%" (
    echo Folder instalasi utama ditemukan.
    goto CHECK_DUPLICATES
)

echo Folder utama TIDAK ditemukan. Melanjutkan ke instalasi...
echo.
goto INSTALL_PROCESS


:: =====================================================
:: CEK DUPLIKASI FOLDER
:: =====================================================
:CHECK_DUPLICATES
set NEED_DUPLICATE=0

for /l %%i in (1,1,5) do (
    set "CHECK_FOLDER=C:\Program Files\Windsor Brokers MT5 Terminal - %%i"
    if not exist "!CHECK_FOLDER!" (
        set NEED_DUPLICATE=1
    )
)

if !NEED_DUPLICATE! EQU 0 (
    echo Semua folder duplikasi sudah ada.
    goto END
)

goto DUPLICATE_PROCESS


:: =====================================================
:: PROSES INSTALL
:: =====================================================
:INSTALL_PROCESS

if not exist "%DOWNLOAD_FILE%" (
    echo Mengunduh installer...
    
    :: Coba TLS 1.2
    powershell -Command ^
      "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12;" ^
      "Invoke-WebRequest -Uri '%DOWNLOAD_URL%' -OutFile '%DOWNLOAD_FILE%'" ^
      && goto DOWNLOAD_OK

    echo TLS 1.2 gagal, mencoba metode lama...

    powershell -Command ^
      "Invoke-WebRequest -Uri '%DOWNLOAD_URL%' -OutFile '%DOWNLOAD_FILE%'" ^
      || (
        echo ERROR: Gagal download file installer
        pause
        exit /b 1
      )
)

:DOWNLOAD_OK
echo Download selesai.
echo.

echo Menjalankan silent installer...
start /wait "" "%DOWNLOAD_FILE%" /auto /S

if not exist "%ORIGINAL_FOLDER%" (
    echo ERROR: Instalasi gagal!
    pause
    exit /b 1
)

echo Instalasi berhasil!
echo.

goto DUPLICATE_PROCESS


:: =====================================================
:: DUPLIKASI + SHORTCUT
:: =====================================================
:DUPLICATE_PROCESS
echo Membuat folder duplikasi + shortcut...

for /l %%i in (1,1,5) do (
    set "NEW_FOLDER=C:\Program Files\Windsor Brokers MT5 Terminal - %%i"

    if not exist "!NEW_FOLDER!" (
        echo Membuat folder %%i
        xcopy "%ORIGINAL_FOLDER%" "!NEW_FOLDER!" /E /I /H /Y >nul
    ) else (
        echo Folder %%i sudah ada, dilewati.
    )

    echo Membuat shortcut %%i...

    powershell -Command ^
      "$ws = New-Object -ComObject WScript.Shell;" ^
      "$s = $ws.CreateShortcut('%STARTUP_FOLDER%\\Windsor-Brokers-%%i.lnk');" ^
      "$s.TargetPath = 'C:\Program Files\Windsor Brokers MT5 Terminal - %%i\terminal64.exe';" ^
      "$s.WorkingDirectory = 'C:\Program Files\Windsor Brokers MT5 Terminal - %%i';" ^
      "$s.Save();"
)

echo.
echo Selesai.
goto END


:: =====================================================
:: END
:: =====================================================
:END
echo.
echo Tekan tombol apapun untuk keluar...
pause >nul
exit /b 0
