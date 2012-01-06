iPerf
Matthew Linton
matthewl@belkin.com

These scripts have been tested under windows XP 32 bit operating systems only, and
may not work with other windows operating systems.

iPerf uses a client and server to measure network throughput between two hosts.

   iperf-server - Start a server that listens on a user specified port.
         The server can listen for either TCP or UDP connections (The client
         and server must match.).

   iperf-client - Uses iPerf to connect and send data to a running server.
         The client can send data using either TCP or UDP (The client and 
         server must match.). This script will generate a throughput log at user
         defined intervals

   iperf-parselog - If the client script failed to finish correctly, you will
         be left with a raw log file.  This script will convert the raw log
         into a more usefull .CSV file so that you can import the data into
         excel.  This is only needed if iperf-client.bat has not already
         generated a CSV file for you

   iperf-watchlog - A helper script that prints out the log information.  This
         script is used by iperf-client.


Running iPerf under Windows Vista:
   Before running any of the scripts, you will first need to properly configure
   iPerf for windows Vista.

      1) Go into the "Lib" directory
      2) Right click on "iperf.exe"
      3) Click on "Properties" in the drop down menu
      4) Click on the "Compatibility" tab
      5) In the "Privilege Level" section, Check "Run this program as an administrator"
      6) Click on "Apply"
      7) Click on "OK"

   You may now run any of the iPerf Scripts under Windows Vista.
   NOTE:  Under Windows Vista, the iPerf scripts will open extra windows.  This
          generates two known issues.

          1 - An extra log file window will open and display nothing.
              You can safely close this window.
          2 - The program will abnormally pause at the end of its run.
              At the end of the run, you can close the logging window and the
              program will terminate normally.