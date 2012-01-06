@ECHO off
@REM tostest-generate
@REM generates a configuration script for tostest from a wireshark capture
@REM Updated 2008-04-01

IF NOT EXIST Lib\sed.exe ECHO sed.exe not found. Unable to continue. & EXIT 1
IF NOT EXIST Lib\gawk.exe ECHO gawk.exe not found. Unable to continue. & EXIT 1
IF NOT EXIST Lib\fmt.exe ECHO fmt.exe not found. Unable to continue. & EXIT 1

:SETUP
SET INFILE=input.txt
SET OUTFILE=output
SET COMMENT=Packet scripting file
SET SOURCEIP=127.0.0.1
SET SOURCEMAC=00:00:00:00:00:00
SET DESTINIP=127.0.0.1
SET DESTINMAC=00:00:00:00:00:00

SET /P INFILE=Enter in the file you would like to convert: 
SET OUTFILE=%INFILE%
SET /P OUTFILE=Enter in a name for the configuration file (w/o extension):
IF EXIST "%OUTFILE%.scr" GOTO OVERWRITELOG
:CONTINUE
SET /P COMMENT=Enter in a file comment (Optional):  
SET /P SOURCEIP=Enter in the source IP address: 
SET /P SOURCEMAC=Enter in the source MAC address: 
SET /P DESTINIP=Enter in the destination IP address: 
SET /P DESTINMAC=Enter in the destination MAC address: 

:PARSEINFO
@REM Convert source IP to hex values
ECHO %SOURCEIP% | Lib\gawk.exe "BEGIN { FS=\".\" } ; { printf \"%%2X~%%2X~%%2X~%%2X\", $1, $2, $3, $4 }" | Lib\sed.exe -e "s/ /0/g"  > "%OUTFILE%.tmp"
FOR /F %%I IN (%OUTFILE%.tmp) DO SET SOURCEIP=%%I
@REM Convert source MAC to propper format
ECHO %SOURCEMAC% > "%OUTFILE%.tmp"
Lib\sed.exe -T -e "s/:/~/g" -e "/[0-9a-fA-F]*/ y/abcdef/ABCDEF/" "%OUTFILE%.tmp" > "%OUTFILE%.tmp2"
FOR /F %%I IN (%OUTFILE%.tmp2) DO SET SOURCEMAC=%%I
@REM Convert destination IP to hex values
ECHO %DESTINIP% | Lib\gawk.exe "BEGIN { FS=\".\" } ; { printf \"%%2X~%%2X~%%2X~%%2X\", $1, $2, $3, $4 }" | Lib\sed.exe -e "s/ /0/g"  > "%OUTFILE%.tmp"
FOR /F %%I IN (%OUTFILE%.tmp) DO SET DESTINIP=%%I
@REM Convert destination MAC to propper format
ECHO %DESTINMAC% > "%OUTFILE%.tmp"
Lib\sed.exe -T -e "s/:/~/g" -e "/[0-9a-fA-F]*/ y/abcdef/ABCDEF/" "%OUTFILE%.tmp" > "%OUTFILE%.tmp2"
FOR /F %%I IN (%OUTFILE%.tmp2) DO SET DESTINMAC=%%I

:SCRCOMMENTS
ECHO Converting File
ECHO # %OUTFILE%.scr > "%OUTFILE%.scr"
ECHO # %COMMENT% >> "%OUTFILE%.scr"
ECHO # ::SOURCEIP::    %SOURCEIP% >> "%OUTFILE%.scr"
ECHO # ::SOURCEMAC::   %SOURCEMAC% >> "%OUTFILE%.scr"
ECHO # ::DESTINIP::    %DESTINIP% >> "%OUTFILE%.scr"
ECHO # ::DESTINMAC::   %DESTINMAC% >> "%OUTFILE%.scr"

:FORMATFILE
@REM Format the file so that NPG and humans can read it
@REM This is a BIG mess.  I had to work around a few batch limitations,  but it works.
Lib\sed.exe -T -e "s/^+-*+-*+-*+$//g" -e "s/|0   |//g" -e "s/^[0-9]*:[0-9]*:[0-9]*,[0-9]*,[0-9]*[ ]*ETHER$//g" -e "s/|/~/g" -e "n;d" "%INFILE%" > "%OUTFILE%.tmp1"
Lib\sed.exe -T -e "/[0-9a-fA-F]*/ y/abcdef/ABCDEF/" "%OUTFILE%.tmp1" > "%OUTFILE%.tmp2"
Lib\sed.exe -T -e "s/%SOURCEIP%/::SOURCEIP::/" -e "s/%DESTINIP%/::DESTINIP::/" -e "s/%SOURCEMAC%/::SOURCEMAC::/" -e "s/%DESTINMAC%/::DESTINMAC::/" "%OUTFILE%.tmp2" > "%OUTFILE%.tmp3"
Lib\sed.exe -T -e "s/~/ /g" -e "s/[ \t]*$//" -e "s/[0-9A-Z: ]*/{&}/g" -e "s/{}/\n[1,100]/g" "%OUTFILE%.tmp3" > "%OUTFILE%.tmp4"
Lib\sed.exe -T -e "s/{/{\n/" -e "s/}/\n}/" -e "s/:: /::\n/g" -e "s/ ::/\n::/g" "%OUTFILE%.tmp4" > "%OUTFILE%.tmp5"
Lib\fmt.exe -s -w 48 "%OUTFILE%.tmp5" >> "%OUTFILE%.scr"

:END
DEL "%OUTFILE%.tmp"
DEL "%OUTFILE%.tmp1"
DEL "%OUTFILE%.tmp2"
DEL "%OUTFILE%.tmp3"
DEL "%OUTFILE%.tmp4"
DEL "%OUTFILE%.tmp5"
ECHO Done
PAUSE
EXIT 0

:OVERWRITELOG
SET ANS=n
ECHO ** "%OUTFILE%.scr" already exists.  Would you like to overwrite this file?
SET /P ANS=   (y/N): 
IF "%ANS%"=="n" GOTO SETUP
IF "%ANS%"=="N" GOTO SETUP
IF "%ANS%"=="y" DEL "%OUTFILE%.scr" & GOTO CONTINUE
IF "%ANS%"=="Y" DEL "%OUTFILE%.scr" & GOTO CONTINUE
ECHO    "%ANS%" is not valid
EXIT 1