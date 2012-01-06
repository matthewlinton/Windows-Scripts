@echo OFF
@REM pagemon
@REM Downloads a user specified webpage every x number of minutes
@REM Updated 2008-01-07

set URL=127.0.0.1
set WAITTIME=15
set LOGFILE=pagemon
set SAVEDIR=savedpages

set /P LOGFILE=Enter in a logfile name (w/o extension): 
echo Enter the URL of the page you would like to monitor:
set /P URL=http://
set /P WAITTIME=Enter the duration between fetches in minutes (%WAITTIME%): 
set /P SAVEDDIR=Enter a directory to save fetches (%SAVEDIR%): 

echo ----------------------------------------------------------
echo Fetching URL, progress can be viewed in "%LOGFILE%"
echo Pages will be saved to "%SAVEDIR%"
echo ----------------------------------------------------------

set /A WAITTIME *= 60
:LOOP
echo %DATE% %TIME% - Fetching "http://%URL%"
<nul (set/p anyvariable=%DATE% - ) >> "%LOGFILE%.log"
Lib\wget.exe -nv -P "%SAVEDIR%" -a "%LOGFILE%.log" http://%URL%
Lib\Wait.exe %WAITTIME%
GOTO LOOP