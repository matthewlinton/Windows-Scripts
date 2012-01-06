@ECHO off
@REM conblast-clean
@REM Clean up leftover netcat processes
@REM Updated 2008-01-07

ECHO Killing NetCat processes
taskkill /IM nc.exe /T /F
ECHO DONE
ECHO If conblast-clean.bat failed to kill any processes, you will need to restart your system to close all NetCat Sessions.  You may also want to lower the maximum number of connections that are opened by contrack-server.bat"
PAUSE
EXIT 0