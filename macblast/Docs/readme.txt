MacBlast
Matthew Linton
matthewl@belkin.com

These scripts have been tested under windows XP 32 bit operating systems only, and
may not work with other windows operating systems.

MacBlast uses macshift to change the MAC address of a client, and simuldate
multiple clients from a single host.

   macblast.bat - changes the MAC address of the specified interface, and
        then refreshes that interface to gain a new IP address with its new
        MAC address.

   restoremac.bat - Restores the network interface's original MAC address.
        This script is only needed if macblast.bat was stopped prematurely.

NOTE: Some network cards do not have the ability to change their MAC address.
      The above scripts will not be able to alter the MAC address of these cards.

