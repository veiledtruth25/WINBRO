@echo off
title VPS Trading Auto Setup
mode con: cols=85 lines=45

echo ================================================
echo  VPS Trading Auto Setup - Windows Server 2012
echo ================================================
echo.

:: =========================================
:: 1. Set High Performance Power Plan
:: =========================================
echo Mengatur Power Plan ke High Performance...
powercfg -setactive SCHEME_MIN

:: =========================================
:: 2. Disable Visual Effects (performance mode)
:: =========================================
echo Mengatur Visual Effect (Best Performance)...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 2 /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v IconsOnly /t REG_DWORD /d 1 /f >nul

:: =========================================
:: 3. Disable Windows Update (hindari restart sendiri)
:: =========================================
echo Menonaktifkan Windows Update...
sc stop wuauserv >nul
sc config wuauserv start= disabled >nul

:: =========================================
:: 4. Enable NTP time sync (waktu presisi untuk trading)
:: =========================================
echo Setting sinkronisasi waktu NTP...
sc config w32time start= auto >nul
net stop w32time >nul
w32tm /config /syncfromflags:manual /manualpeerlist:"pool.ntp.org" >nul
w32tm /config /reliable:yes /update >nul
net start w32time >nul
w32tm /resync >nul

:: =========================================
:: 5. Install .NET Framework 4.8 (penting utk banyak EA)
:: =========================================
echo Mengunduh dan menginstal .NET Framework 4.8...
set NET48_URL=https://download.visualstudio.microsoft.com/download/pr/5a9a65fb-d8df-4cb3-9f9c-6639a40c455e/3da497563f79a53236b0fdbdb8938a0b/ndp48-x86-x64-allos-enu.exe
set NET48_FILE=%temp%\ndp48.exe

bitsadmin /transfer "NET48" "%NET48_URL%" "%NET48_FILE%" >nul 2>&1
if exist "%NET48_FILE%" (
    "%NET48_FILE%" /q /norestart
) else (
    echo Gagal download .NET 4.8
)

:: =========================================
:: 6. Optimize RDP Compression (respons lebih cepat)
:: =========================================
echo Mengoptimalkan RDP Compression...
reg add "HKLM\Software\Policies\Microsoft\Windows NT\Terminal Services" /v CompressionAlgorithm /t REG_DWORD /d 1 /f >nul

:: =========================================
:: 7. Disable Server Manager auto-open (ganggu RDP)
:: =========================================
echo Menonaktifkan auto-open Server Manager...
reg add "HKLM\Software\Microsoft\ServerManager" /v DoNotOpenServerManagerAtLogon /t REG_DWORD /d 1 /f >nul

:: =========================================
:: 8. Cleanup temporary files
:: =========================================
echo Membersihkan temporary file...
del /q /f %temp%\* >nul 2>&1
del /q /f C:\Windows\Temp\* >nul 2>&1

echo.
echo ================================================
echo Setup selesai! VPS siap untuk trading otomatis.
echo Anda bisa reboot VPS sekarang.
echo ================================================
pause
