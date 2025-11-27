@echo off
setlocal enabledelayedexpansion

set "DOWNLOAD_URL=https://veiledtruth25.github.io/WINBRO/EA/MT4/COPYLOT Master.ex4"
set "DOWNLOAD_FILE=COPYLOT Master.ex4"

if not exist "%DOWNLOAD_FILE%" (
    echo Mengunduh installer...
    
    :: Coba TLS 1.2
    powershell -Command ^
      "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12;" ^
      "Invoke-WebRequest -Uri '%DOWNLOAD_URL%' -OutFile '%DOWNLOAD_FILE%'" ^
      && goto DOWNLOAD_MT4Master_OK

    echo TLS 1.2 gagal, mencoba metode lama...

    powershell -Command ^
      "Invoke-WebRequest -Uri '%DOWNLOAD_URL%' -OutFile '%DOWNLOAD_FILE%'" ^
      || (
        echo ERROR: Gagal download file installer
        pause
        exit /b 1
      )
)
:DOWNLOAD_MT4Master_OK

set "DOWNLOAD_URL=https://veiledtruth25.github.io/WINBRO/EA/MT4/COPYLOT Client.ex4"
set "DOWNLOAD_FILE=COPYLOT Client.ex4"

if not exist "%DOWNLOAD_FILE%" (
    echo Mengunduh installer...
    
    :: Coba TLS 1.2
    powershell -Command ^
      "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12;" ^
      "Invoke-WebRequest -Uri '%DOWNLOAD_URL%' -OutFile '%DOWNLOAD_FILE%'" ^
      && goto DOWNLOAD_MT4Client_OK

    echo TLS 1.2 gagal, mencoba metode lama...

    powershell -Command ^
      "Invoke-WebRequest -Uri '%DOWNLOAD_URL%' -OutFile '%DOWNLOAD_FILE%'" ^
      || (
        echo ERROR: Gagal download file installer
        pause
        exit /b 1
      )
)
:DOWNLOAD_MT4Client_OK


set "DOWNLOAD_URL=https://veiledtruth25.github.io/WINBRO/EA/MT5/COPYLOT Master.ex5"
set "DOWNLOAD_FILE=COPYLOT Master.ex5"

if not exist "%DOWNLOAD_FILE%" (
    echo Mengunduh installer...
    
    :: Coba TLS 1.2
    powershell -Command ^
      "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12;" ^
      "Invoke-WebRequest -Uri '%DOWNLOAD_URL%' -OutFile '%DOWNLOAD_FILE%'" ^
      && goto DOWNLOAD_MT5Master_OK

    echo TLS 1.2 gagal, mencoba metode lama...

    powershell -Command ^
      "Invoke-WebRequest -Uri '%DOWNLOAD_URL%' -OutFile '%DOWNLOAD_FILE%'" ^
      || (
        echo ERROR: Gagal download file installer
        pause
        exit /b 1
      )
)
:DOWNLOAD_MT5Master_OK

set "DOWNLOAD_URL=https://veiledtruth25.github.io/WINBRO/EA/MT5/COPYLOT Client.ex5"
set "DOWNLOAD_FILE=COPYLOT Client.ex5"

if not exist "%DOWNLOAD_FILE%" (
    echo Mengunduh installer...
    
    :: Coba TLS 1.2
    powershell -Command ^
      "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12;" ^
      "Invoke-WebRequest -Uri '%DOWNLOAD_URL%' -OutFile '%DOWNLOAD_FILE%'" ^
      && goto DOWNLOAD_MT5Client_OK

    echo TLS 1.2 gagal, mencoba metode lama...

    powershell -Command ^
      "Invoke-WebRequest -Uri '%DOWNLOAD_URL%' -OutFile '%DOWNLOAD_FILE%'" ^
      || (
        echo ERROR: Gagal download file installer
        pause
        exit /b 1
      )
)
:DOWNLOAD_MT5Client_OK


echo Download selesai.
echo.
echo Tekan tombol apapun untuk keluar...
pause >nul
exit /b 0