@echo off
title Windows Server 2012 Trading VPS Auto Setup
echo ===============================================
echo  Trading VPS Auto Setup - Windows Server 2012
echo ===============================================
echo.

:: CEK ADMIN
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Jalankan file ini sebagai Administrator!
    pause
    exit /b
)

echo [1/15] Mengatur power plan ke High Performance...
powercfg -setacvalueindex SCHEME_MIN SUB_VIDEO VIDEOIDLE 0
powercfg -setacvalueindex SCHEME_MIN SUB_VIDEO VIDEOIDLE 0
powercfg -setactive SCHEME_MIN

echo [2/15] Menonaktifkan Windows Update...
sc config wuauserv start= disabled
net stop wuauserv

echo [3/15] Menonaktifkan Firewall (opsional)...
netsh advfirewall set allprofiles state off

echo [4/15] Menonaktifkan Sleep / Hibernate...
powercfg -h off

echo [5/15] Menonaktifkan Screensaver...
reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v ScreenSaveActive /t REG_SZ /d 0 /f

echo [6/15] Disable DEP (Data Execution Prevention)...
bcdedit.exe /set nx AlwaysOff

echo [7/15] Download software pendukung trading...

set DOWNLOAD_DIR="C:\TRADING_SETUP"
mkdir %DOWNLOAD_DIR% >nul 2>&1

echo   - Chrome
powershell -Command "(New-Object Net.WebClient).DownloadFile('https://dl.google.com/tag/s/appguid%3D%7B8A69D345-D564-463C-AFF1-A69D9E530F96%7D%26iid%3D%7BD081E0BD-028C-3779-9973-A3229AEC8BCD%7D%26lang%3Den%26browser%3D0%26os%3D0%26arch%3Dx64%26appname%3DGoogle%2520Chrome%26needsadmin%3Dprefers/edgedl/chrome/install/GoogleChromeStandaloneEnterprise64.msi', '%DOWNLOAD_DIR%\chrome.msi')"

echo   - .NET Framework 4.8
powershell -Command "(New-Object Net.WebClient).DownloadFile('https://download.visualstudio.microsoft.com/download/pr/5a9a65fb-d8df-4cb3-9f9c-6639a40c455e/3da497563f79a53236b0fdbdb8938a0b/ndp48-x86-x64-allos-enu.exe', '%DOWNLOAD_DIR%\net48.exe')"

echo   - Visual C++ Redistributable Pack (2005–2022)
powershell -Command "(New-Object Net.WebClient).DownloadFile('https://aka.ms/vs/17/release/vc_redist.x64.exe', '%DOWNLOAD_DIR%\vcredist2022.exe')"

echo   - DirectX Runtime
powershell -Command "(New-Object Net.WebClient).DownloadFile('https://download.microsoft.com/download/1/7/1/17154713-5F7F-4B0C-AE3F-DA3A3BC74D1C/directx_Jun2010_redist.exe', '%DOWNLOAD_DIR%\directx.exe')"

echo   - 7zip
powershell -Command "(New-Object Net.WebClient).DownloadFile('https://www.7-zip.org/a/7z2301-x64.exe', '%DOWNLOAD_DIR%\7zip.exe')"

echo   - Notepad++
powershell -Command "(New-Object Net.WebClient).DownloadFile('https://github.com/notepad-plus-plus/notepad-plus-plus/releases/download/v8.6.3/npp.8.6.3.Installer.x64.exe', '%DOWNLOAD_DIR%\npp.exe')"

echo [8/15] Install Chrome...
msiexec /i %DOWNLOAD_DIR%\chrome.msi /quiet /norestart

echo [9/15] Install .NET 4.8...
%DOWNLOAD_DIR%\net48.exe /quiet /norestart

echo [10/15] Install VC++ Redistributable...
%DOWNLOAD_DIR%\vcredist2022.exe /install /quiet /norestart

echo [11/15] Install DirectX...
%DOWNLOAD_DIR%\directx.exe /Q

echo [12/15] Install 7zip...
%DOWNLOAD_DIR%\7zip.exe /S

echo [13/15] Install Notepad++...
%DOWNLOAD_DIR%\npp.exe /S

echo [14/15] Optimasi jaringan untuk latency rendah forex...

echo   - Disable Nagle Algorithm
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces" /v TcpAckFrequency /t REG_DWORD /d 1 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces" /v TCPNoDelay /t REG_DWORD /d 1 /f

echo   - Enable QoS
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Psched" /v NonBestEffortLimit /t REG_DWORD /d 0 /f

echo [15/15] Membersihkan temporary file...
del /s /q C:\Windows\Temp\*
del /s /q %temp%\*

echo ===============================================
echo   SETUP SELESAI!
echo   VPS siap digunakan untuk trading otomatis.
echo ===============================================
pause
exit
