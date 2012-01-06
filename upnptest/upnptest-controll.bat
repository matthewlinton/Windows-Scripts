@ECHO off
@REM upnptest-controll
@REM Simplifies the setup for IGDTest.exe, and logs the output
@REM Updated 2008-01-07

IF NOT EXIST Lib\IGDTest.exe ECHO Could not find IGDTest.exe. Unable to continue. & EXIT 0
IF NOT EXIST Lib\tail.exe ECHO Could not find tail.exe.
IF NOT EXIST Lib\grep.exe ECHO Could not find grep.exe.
IF NOT EXIST Lib\sed.exe ECHO Could not find sed.exe.

:EULA
SET EULA=n
ECHO Before running Microsoft's IGD UPnP test, you must first review and agree
ECHO to the "IGD UPnP EULA". THe EULA is located in the "Docs" folder.
SET /P EULA=I have read and agree to the "IGD UPnP EULA" (y/N): 
IF "%EULA%"=="y" GOTO SETUP
IF "%EULA%"=="Y" GOTO SETUP
GOTO END

:SETUP
SET LOGFILE=logfile
SET TEST=all
SET LCLHOST1=127.0.0.1
SET LCLHOST2=127.0.0.1
SET RMTHOST1=127.0.0.1
SET RMTHOST2=127.0.0.1

SET /P LOGFILE=Enter in a logfile name (w/o extension): 
IF EXIST "%LOGFILE%.log" GOTO OVERWRITELOG
:CONTINUE
ECHO -------------------- LAN Hosts ---------------------
SET /P LCLHOST1=Enter in LAN host #1: 
SET /P LCLHOST2=Enter in LAN host #2: 
ECHO -------------------- WAN Hosts ---------------------
SET /P RMTHOST1=Enter in WAN host #1: 
SET /P RMTHOST2=Enter in WAN host #2: 
ECHO.
SET /P TEST=Enter in the test to run (%TEST%): 

ECHO.
ECHO Starting IGD UPnP test.  Results will be displayed when test has finished.
ECHO Logging results to "%LOGFILE%.log"
Lib\IGDTest.exe /privateip1:%LCLHOST1% /privateip2:%LCLHOST2% /publicip1:%RMTHOST1% /publicip2:%RMTHOST2% /%TEST% >> "%LOGFILE%.log"

:END
ECHO Done.
pause
exit 0

:OVERWRITELOG
SET ANS=n
ECHO ** "%LOGFILE%.log" already exists.  Would you like to overwrite this file?
SET /P ANS=   (y/N): 
IF "%ANS%"=="n" GOTO SETUP
IF "%ANS%"=="N" GOTO SETUP
IF "%ANS%"=="y" del "%LOGFILE%.log" & GOTO CONTINUE
IF "%ANS%"=="Y" del "%LOGFILE%.log" & GOTO CONTINUE
ECHO    "%ANS%" is not valid
GOTO END