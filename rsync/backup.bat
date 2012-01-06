@ECHO off
SET %SCRIPTNAME=backup.bat
@REM backup files to an rsync server
@REM This script requires a working version of cygwin (http://www.cygwin.com/)
@REM with rsync and ssh installed.
@REM Updated 2010-09-29

:CONFIG
@REM Please change the following settings to meet your needs.
SET BACKUPHOST=server@example.com
SET BACKUPTYPE=DAILY
SET SOURCEDIR=%HomePath%
SET USER=default
SET GROUP=default
SET SSHKEYFILE=%HomePath%\.ssh\keyfile
SET LOGFILE=%HomePath%\backup.log

:CONFIGCYGWIN
SET CYGWINBIN=%SystemDrive%\cygwin\bin
SET BINRSYNC=%CYGWINBIN%\rsync.exe
SET BINSSH=%CYGWINBIN%\ssh.exe
SET BINGREP=%CYGWINBIN%\grep.exe

:CONFIGOTHER
SET NUMPING=3

@REM ***** DO NOT EDIT BELOW THIS LINE ****************************************

ECHO >> %LOGFILE%
ECHO %DATE% %TIME% : INFO : Starting backup of %SOURCEDIR% to %BACKUPHOST%. >> %LOGFILE%

:BININIT
IF NOT EXIST %CYGWINBIN% ECHO %DATE% %TIME% : ERROR : Could not find Cygwin installation. >> %LOGFILE% & GOTO FAILEND
IF NOT EXIST %BINRSYNC% ECHO %DATE% %TIME% : ERROR : Could not find rsync.exe in %CYGWINBIN% >> %LOGFILE% & GOTO FAILEND
IF NOT EXIST %BINSSH% ECHO %DATE% %TIME% : ERROR : Could not find ssh.exe in %CYGWINBIN% >> %LOGFILE% & GOTO FAILEND
IF NOT EXIST %BINGREP% ECHO %DATE% %TIME% : ERROR : Could not find grep.exe in %CYGWINBIN% >> %LOGFILE% & GOTO FAILEND

:OPTIONS
@REM TODO : Take commandline options

:START

@REM ** Check to see if our host is up ********
:STARTSERVERPING
ping -n 1 %BACKUPHOST% > NUL 2&>1
IF %ERRORLEVEL% == 0 GOTO ENDSERVERPING
SET /A NUMPING = %NUMPING% - 1
IF %NUMPING% GTR 0 GOTO STARTSERVERPING
ECHO %DATE% %TIME% : ERROR : %BACKUPHOST% does not seem to be up. Unable to ping host. >> %LOGFILE%
ECHO %DATE% %TIME% : ERROR : %SCRIPTNAME% exiting without performing backup >> %LOGFILE%
GOTO FAILEND
:ENDSERVERPING

:STARTMOVEOLD
@REM TODO : copy over current backup to archived backup.
@REM this should be based on the type of backup. hourly, daily, weekly, etc...
:ENDMOVEOLD

:FAILEND
ECHO %DATE% %TIME% : ERROR : The backup has failed! >> %LOGFILE%
EXIT 1

:SUCCESSEND
ECHO %DATE% %TIME% : SUCCESS : The backup has finished. >> %LOGFILE%
EXIT 0
