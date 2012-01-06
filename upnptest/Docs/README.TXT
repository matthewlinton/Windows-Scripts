upnptest
Matthew Linton
matthewl@belkin.com
Updated: 2008-01-07

upnptest uses Microsoft's IGD UPnP testing suite to verify the functionality of UPnP
gateways.  THese scripts are designed to simplify the process of running the executables.
Microsoft's IGD UPnP testing suite requires that you have read the Microsoft IGD UPnP
testing suite EULA (Loated in this folder).

upnptest-client:
      Launches "NXPClient.exe", the client app that must be run on each host.
      Results are placed in the logfile.

upnptest-controll:
      Launches "IGDTest.exe" with the correct user defined configuration.
      Results are placed in the logfile.