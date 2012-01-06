@ECHO OFF
:CONFIG
@REM Please change the following settings to meet your needs.
SET BACKUPHOST=mrgone.dhdfgdfhfdngdfgh5y4rtfgb5w45h.net
SET SOURCEDIR=%HomePath%
SET USER=psycoth
SET GROUP=users
SET LOGFILE=%HomePath%\backup.log
SET SSHKEYFILE=%HomePath%\.ssh\keyfile
SET NUMPING=3
SET CYGWINBIN=%SystemDrive%\cygwin\bin

@REM ***** DO NOT EDIT BELOW THIS LINE ****************************************

:BINCONFIG
SET BINRSYNC=%CYGWINBIN%\rsync.exe
SET BINSSH=%CYGWINBIN%\ssh.exe
SET BINGREP=%CYGWINBIN%\grep.exe

:TESTING
ECHO BEGIN TESTING CODE
@REM ##########################################################################

:STARTSERVERPING
echo %NUMPING%
ping -n 1 %BACKUPHOST% > NUL 2>&1
IF %ERRORLEVEL% == 0 GOTO ENDSERVERPING
SET /A NUMPING = %NUMPING% - 1
IF %NUMPING% GTR 0 GOTO STARTSERVERPING
ECHO %BACKUPHOST% does not seem to be up. Unable to ping host.
ECHO %SCRIPTNAME% exiting without performing backup
GOTO FAILEND
:ENDSERVERPING


@REM ##########################################################################
ECHO END TESTING CODE
GOTO END

:FAILEND
ECHO The backup has failed!
GOTO END

:SUCCESSEND
ECHO %DATE% : The backup has finished.

:END