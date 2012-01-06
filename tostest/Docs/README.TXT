tostest
Matthew Linton
matthewl@belkin.com

The tostest suit is designed to simulate various types of connections and
traffic patterns for ToS mangling.  These scripts send and receive a small
number of packets in order to verify that ToS mangling is working correctly.
These scripts were not designed to test QoS throughput handling.

SCRIPTS
tostest-cap		A helper script used by "tostest-receive" designed to
			capture packets.
tostest-generate	Generates a configuration file from a Wireshark
			session that has been saved in the K12 text file
			format.
tostest-receive		Generates an analysis of packets seen by a host.
tostest-send		Generates a series of packets to be sent through the
			router.


VARIABLES
This section contains a listing of all variables used when creating tostest
scripts.

::SOURCEMAC::	The source MAC address
::DESTINMAC::	The destination MAC address
::SOURCEIP::	The source IP address
::DESTINIP::	The destination IP address
				
TODO:
::SOURCENET::	The source network
		This should always be followed by ".xxx" where xxx is a number
		between 0-255.  For simplicity, it currently assumed that the
		netmask of all networks is 255.255.255.0
		E.G.  ::SOURCENET::.100
::DESTINNET::	The destination network
		Same as ::SOURCENET:: above, but for the destination network.
::RANDIP::	A random IP address.
::RANDMAC::	A random MAC address.
::RANDPORT::	A random port between 1 and 65535 inclusive.
::RANDSEQACK::	A random SEQ or ACK number.
::RANDHEX::	A random hex value.


NOTE: All random variables will be different each time they are called in the
	script.