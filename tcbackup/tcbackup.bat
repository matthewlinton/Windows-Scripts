@echo off
@REM tcbackup - Backup files to a truecrypt drive
@REM Requires:    cygwin - http://cygwin.com/
@REM              TrueCrypt - http://www.truecrypt.org/

SET BACKUPSOURCE=c:\users\default\
SET BACKUPDESTINATION=z:\

SET CYGWINBIN=%SystemDrive%\cygwin\bin

SET BINTRUECRYPT=%PROGRAMFILES%\TrueCrypt\TrueCrypt.exe
SET BINRSYNC=%CYGWINBIN%\rsync.exe

rsync -a --exclude /cygdrive/e/users/Matthew\ Linton/backup/ /cygdrive/e/users/Matthew\ Linton/ /cygdrive/z
/