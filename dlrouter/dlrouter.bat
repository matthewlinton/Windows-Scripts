@echo off
@REM dlrouter
@REM Uses a config file to download every thing it can from the router
@REM Updated 2008-02-13

IF NOT EXIST Lib\grep.exe ECHO grep.exe not found. Unable to continue. & EXIT 1
IF NOT EXIST Lib\wget.exe ECHO wget.exe not found. Unable to continue & EXIT 1
IF NOT EXIST Lib\sed.exe ECHO sed.exe not found. Unable to continue & EXIT 1
IF NOT EXIST Lib\sort.exe ECHO sort.exe not found. Unable to continue. & EXIT 1

:SETUP
SET CONF=Conf
SET CONFIGFILE=router.txt
SET IPADDY=192.168.2.1
SET DLTEMP=ROUTERFILES
SET LOGFILE=logfile

SET /P LOGFILE=Enter in a log name (w/o extension): 
IF EXIST "%LOGFILE%-wget.log" GOTO OVERWRITELOG
:CONTINUE

ECHO Available Routers:
ECHO ---------------------------------------------------
DIR /B /D %CONF% | Lib\sed.exe -e "s/^/-- /g"
ECHO ---------------------------------------------------
SET /P CONFIGFILE=Enter a URL list to use: 
IF NOT EXIST "%CONF%\%CONFIGFILE%" ECHO configuration file (%CONFIGFILE%) not found. & GOTO SETUP

SET /P IPADDY=Enter in the IP address of the router (%IPADDY%): 

ECHO.
ECHO ** Make sure that this host is logged into the router **
PAUSE

:FETCH
<NUL (SET/p anyvariable=  - Fetching Pages... )
@REM batch doesn't seem to like quoting in the for statement. config files cannot have spaces.
@REM This should be OK as long as no one changes %CONF%, or creates a config file that has spaces, but I should find a fix for this.
FOR /F %%I IN ( %CONF%\%CONFIGFILE% ) DO Lib\wget.exe -a "%LOGFILE%-wget.log" -nd -nc -r -P "%DLTEMP%" http://%IPADDY%/%%I
ECHO DONE

:GETROUTERSETTINGS
@REM This currently only works for the 8232 and 8632 Other routers may require a different set of rules.
@REM If this is the case, the following will have to be rewritten to handle different routers.
@REM for the 8232 and 8632, you need to manually download the config file before the script can fetch it automaticly. 
@REM I will have to figure out the correct URL and add it to the config file
<NUL (SET/p anyvariable=  - Fetching Router Settings... )
TYPE %DLTEMP%\*.cfg 2>NUL | FIND "" /V | Lib\sed.exe -T -e "s/=/,/g" -e "s/^.\{6\}//g" > "%LOGFILE%-config.csv"
ECHO DONE

:GETVIRTUALSERVERS
@REM This currently only works for the 8232 and 8632 Other routers may require a different set of rules.
@REM If this is the case, the following will have to be rewritten to handle different routers.
<NUL (SET/p anyvariable=  - Parsing Virtual Server Presets... )
ECHO Entry Name,,Service Name,IPort Start,IPort End,Protocol,,HPort Start,HPort End > "%LOGFILE%-VirtualServers.csv"
@REM the windows shell does not allow quotes when using wild cards.  I need to find a way around this.
TYPE %DLTEMP%\* 2>NUL | Lib\grep.exe -U "new ObjVirtualServer" > "%LOGFILE%-VirtualServers.tmp"
TYPE "%LOGFILE%-VirtualServers.tmp" | Lib\sed.exe -T -e "s/);//g" -e "s/, /,/g" -e "s/^ *//g" -e "s/^.\{50\}//g" -e "s/[er]*(//g" | Lib\sort.exe >> "%LOGFILE%-VirtualServers.csv"
ECHO DONE

:CLEANUP
DEL "%LOGFILE%-VirtualServers.tmp"

:END
ECHO.
ECHO DONE
PAUSE
EXIT 0

:OVERWRITELOG
SET ANS=n
ECHO ** "%LOGFILE%.log" already exists.  Would you like to overwrite this file?
SET /P ANS=   (y/N): 
IF "%ANS%"=="n" GOTO SETUP
IF "%ANS%"=="N" GOTO SETUP
IF "%ANS%"=="y" DEL "%LOGFILE%.log" & GOTO CONTINUE
IF "%ANS%"=="Y" DEL "%LOGFILE%.log" & GOTO CONTINUE
ECHO    "%ANS%" is not valid
GOTO END