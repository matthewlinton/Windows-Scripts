*****
***** uses rsync and ssh to backup a local directory.

FILES
- backup.bat
   Windows script to perform a backup from the client to the server.

- backup.sh
   Bash script to perform a backup from the client to the server.

REQUIREMENTS
The following are required to get ***** working.
Host:
- Cygwin (http://www.cygwin.com/) with:
   - rsync
   - ssh
        
Server:
- rsync server with a directory set to sync to
   
- ssh server (e.g. openssh)


