@echo off
title NZ Maintenance Toolkit
color 0A
mode con: cols=100 lines=40

net session >nul 2>&1
if %errorlevel% neq 0 (
cls
echo.
echo ================================================================================
echo 			ADMINISTRATOR PRIVILEGES REQUIRED			
echo ================================================================================
echo.
echo Right-click this file and choose:
echo Run as Administrator
echo.
pause
exit
)

:MENU
cls
echo.
echo ================================================================================
echo.
echo				NZ MAINTENANCE TOOLKIT					                     
echo.
echo			     Designed and Developed by NZ
echo.
echo ================================================================================
echo.
echo  Computer : %COMPUTERNAME%
echo  User     : %USERNAME%
echo  Date     : %DATE%
echo  Time     : %TIME:~0,8%
echo.
echo --------------------------------------------------------------------------------
echo.
echo  CLEAN ^& OPTIMIZE
echo    [1] Quick Cleanup
echo    [2] Deep Maintenance
echo.
echo  REPAIR
echo    [3] Network Repair
echo    [4] Restart Windows Explorer
echo    [5] GPU Refresh
echo.
echo  INFORMATION
echo    [6] System Information
echo    [7] Battery Report
echo    [8] Network Information
echo.
echo  UTILITIES
echo    [9] Windows Administrative Tools
echo   [10] Flush DNS Cache
echo   [11] Restart Windows Audio
echo   [12] Restart Print Spooler
echo   [13] Restart Windows Update Service
echo.
echo    [0] Exit
echo.
echo ================================================================================
set /p option=Select Option:

if "%option%"=="1" goto QUICK
if "%option%"=="2" goto DEEP
if "%option%"=="3" goto NETWORK
if "%option%"=="4" goto EXPLORER
if "%option%"=="5" goto GPU
if "%option%"=="6" goto SYSINFO
if "%option%"=="7" goto BATTERY
if "%option%"=="8" goto NETINFO
if "%option%"=="9" goto TOOLS
if "%option%"=="10" goto DNS
if "%option%"=="11" goto AUDIO
if "%option%"=="12" goto PRINT
if "%option%"=="13" goto UPDATE
if "%option%"=="0" exit
goto MENU

:QUICK
cls
echo ================================================================================
echo                               QUICK CLEANUP
echo ================================================================================
choice /c YN /m "Continue"
if errorlevel 2 goto MENU
echo Cleaning User Temp...
del /f /s /q "%temp%\*" >nul 2>&1
for /d %%G in ("%temp%\*") do rd /s /q "%%G" >nul 2>&1
echo Cleaning Windows Temp...
del /f /s /q "C:\Windows\Temp\*" >nul 2>&1
for /d %%G in ("C:\Windows\Temp\*") do rd /s /q "%%G" >nul 2>&1
echo Emptying Recycle Bin...
powershell -NoProfile -Command "Clear-RecycleBin -Force" >nul 2>&1
echo Flushing DNS...
ipconfig /flushdns >nul
echo Resetting Store Cache...
start /wait wsreset.exe
echo Running Disk Cleanup...
cleanmgr /verylowdisk
echo Done.
pause
goto MENU

:DEEP
cls
DISM /Online /Cleanup-Image /StartComponentCleanup
sfc /scannow
pause
goto MENU

:NETWORK
cls
ipconfig /flushdns
ipconfig /release
ipconfig /renew
netsh winsock reset
netsh int ip reset
echo Restart PC to complete network repair.
pause
goto MENU

:EXPLORER
taskkill /f /im explorer.exe >nul
timeout /t 1 >nul
start explorer.exe
pause
goto MENU

:GPU
cls
echo Press WIN + CTRL + SHIFT + B
pause
goto MENU

:SYSINFO
systeminfo
pause
goto MENU

:BATTERY
powercfg /batteryreport
pause
goto MENU

:NETINFO
ipconfig /all
pause
goto MENU

:TOOLS
start control
start appwiz.cpl
start devmgmt.msc
start diskmgmt.msc
start services.msc
start taskmgr
start eventvwr.msc
start msconfig
start perfmon
start resmon
goto MENU

:DNS
ipconfig /flushdns
pause
goto MENU

:AUDIO
net stop Audiosrv
net start Audiosrv
pause
goto MENU

:PRINT
net stop spooler
net start spooler
pause
goto MENU

:UPDATE
net stop wuauserv
net start wuauserv
pause
goto MENU
