ConBlast
Matthew Linton
matthewl@belkin.com
Updated 2007-01-07

Conblast uses netcat to open persistant connections between two hosts.

   conblast-server.bat - Opens a user defined range of ports using NetCat.
            These ports will remain open and listen for incoming connections.
            WHen a connection is terminated by the client, these server ports
            will remain open and wait for another netcat client to connect.

   conblast-grind.bat  - Uses netcat to open and close connections to the conblast
            server on a user defined range of ports.  The number of rounds and
            concurrent connections are listed in the text logfile.

   conblast-hold.bat - Uses netcat to attempt to connect to a user defined
            range of ports on the conblast server. Holds the connections untill
            user terminates process.

   conblast-track.bat  - Uses the windows netstat command to determine the number
            of established connections on a host.  This information is put into
            a log file along with the date and time the measurement was taken.

   conblast-clean.bat  - If conblast-server.bat, conblast-client.bat, or
            conblast-grind.bat fail to close properly, they may leave behind a
            large number of running NetCat processes.  This script will close
            those open NetCat sessions automatically.


WARNING: The conblast client and server scripts can open a large number netcat
         processes.  This can be too much for some systems to handle.  Currently,
         the upper limit is 400 connections. This should be fine for most systems,
         but may lock up older systems, or systems with limited memory.

NOTE: you can not run conblast-grind on the same host with conblast-server or
      conblast-client.  Conblast grind will end up killing all your netcat
      processes.  This is per design.  In the process of connecting and
      disconnecting, conblast grind kills all netcat processes in order to ensure
      that the system does not get overloaded.

NOTE: Because our antivirus software detects netcat as a virus, it was removed from
      the "Lib" directory.  You can download the latest version from 
      "http://netcat.sourceforge.net/" and add "nc.exe" to the "Lib" directory.
