ddclient
========

ddclient for self hosted dyndns service

[Team](#team-member)
====

# <a name="team-members"></a>Team Members
* "Rüdiger Pretzlaff" <rpr@9it.de>


Installation
============

Copy the files ddclient and DDclient.pl to any location. 
For example: ~/bin/ 

Edit the file and DDclient.pl supply your data.

Update crontab: 
crontab -e 

*/10 * * * * ${HOME}/bin/DDclient

Fritz!Box User
==============

* Open in the browser Webobfläche the Fritzbox: http://fritz.box 
* Login 
* Click on "Internet" -> "Share" -> "Dynamic DNS" 
* Choose from Benutzerdenfiniert. 
* UpdateURL: http://9it.eu/dyndns/update.pl?apikey=&lt;YOURAPIKEY>&ip=&lt;ipaddr>&ip6=&lt;ip6addr>&user=&lt;username>&password=&lt;pass> 
	* Register with the update URL only APIKEY. All other parameters (username, password, ...) do not change.
* Domain: YOURSUBDOMAIN.pretzlaff.co 
* User Name: YOURUSERNAME 
* Password: YOURPASSWORD

TODO
====

* add Setup/INIT For the first installation
* OS-X Client (using LaunchAgent)
* Add Synology NAS Support


