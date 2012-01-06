SurfTest
Matthew Linton
matthewl@belkin.com

These scripts have been tested under windows XP 32 bit operating systems only, and
may not work with other windows operating systems.

Surftest scripts attempt to simulate a single user or multiple users surfing the web
using wget.  This activity includes downloading webpages, images, and any other content
found on a page.  The surftest scripts have not been designed to download from sites
that require login information.

   surftest.bat - This script simulates user(s) surfing the web.
       for each URL in the selected configuration file, a new instance of wget will
       open and begin crawling starting from that URL.  Each instance of wget will
       follow every link that it finds (unless told not to by "robots.txt" files)
       untill it is canceled or exausts all available links (This is unlikely as wget
       has been set up to cross over to other domains).

WARNING: Some systems have trouble handling large numers of wget processes at once.
         "urllst-heavy.txt" file contins 17 starting URLS.  This may cause problems with
         some systems.

WARNING: wget saves data to a temp directory ("urltmp" in the local directory by default).
         This is per design and necessary for the correct operation of wget.  However,
         if wget is left to run for long periods of time (24+ hours), it can generate a
         large number of folders and files.  This may cause some systems to become slow
         or to crash when viewing or attempting to delete the temp directory. I have not
         had this do damage to any system, yet.

NOTE: Some sites automaticly block known automated webpage fetching scripts such as wget
      In order to avoid this, the useragent string has been changed (using the option
      "-U" to set the useragent in wget).  At the time this was written, most of the
      websites listed in the configuration files would allow the script to download from
      their sites.  However, in the future it may be necessary to change this useragent
      string.