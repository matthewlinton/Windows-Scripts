@ECHO off
@REM upnptest-client
@REM Launches NXPClient.exe and logs the output.
@REM Updated 2008-01-07

IF NOT EXIST Lib\NXPClient.exe ECHO Could not find NXPClient.exe. Unable to continue. & EXIT 1

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

SET /P LOGFILE=Enter in a logfile name (w/o extension): 
IF EXIST "%LOGFILE%.log" GOTO OVERWRITELOG
:CONTINUE

ECHO Starting IGD Client. Logging results to "%LOGFILE%.log"
ipconfig
Lib\NXPClient.exe >> "%LOGFILE%.log"

:END
ECHO Done.
PAUSE
EXIT 0

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