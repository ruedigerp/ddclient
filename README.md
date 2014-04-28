
* [Description](#description)
* [Team](#team-members)
* [Test Client](#testclient)
* [Installation](#installation)
* [Fritzbox](#fritzbox)
* [OS-X LaunchAgent](#osx)
* [Todo](#todo)
* [License](#license)

# <a name="description"></a>Description

ddclient for self hosted dyndns service


# <a name="team-members"></a>Team Members
* "Rüdiger Pretzlaff" <rpr@9it.de>

# <a name="testclient"></a>Test Client 

Send e-mail to "Rüdiger Pretzlaff" <rpr@9it.de> and request a test account.

Tested with Linux, OS X and Fritzbox. 

Tester for Synology station are welcome.


# <a name="installation"></a>Installation

Copy the files ddclient and DDclient.pl to any location. 
For example: ~/bin/ 

Edit the file and DDclient.pl supply your data.
Or run: DDclient -setup

Update crontab: 
crontab -e 

*/10 * * * * ${HOME}/bin/DDclient

# <a name="fritzbox"></a>Fritz!Box User

* Open in the browser Webobfläche the Fritzbox: http://fritz.box 
* Login 
* Click on "Internet" -> "Share" -> "Dynamic DNS" 
* Choose from Benutzerdenfiniert. 
* UpdateURL: http://9it.eu/dyndns/update.pl?apikey=&lt;YOURAPIKEY>&ip=&lt;ipaddr>&ip6=&lt;ip6addr>&user=&lt;username>&password=&lt;pass> 
	* Register with the update URL only APIKEY. All other parameters (username, password, ...) do not change.
* Domain: YOURSUBDOMAIN.pretzlaff.co 
* User Name: YOURUSERNAME 
* Password: YOURPASSWORD

# <a name="osx"></a>OS-X LaunchAgent

* LaunchAgent

Run:
```bash
DDClient -launchagent
```

or edit file manuell:

LaunchAgent plist-File: dyndns.9it.eu.plist


* Get your Username in Terminal:

```bash
id -u -n
```

* Edit .plist-File

Edit lines 11, 18 and 20 in dyndns.9it.eu.plist. Replace USERNAME with your username.

```xml
... 
 11     <string>/Users/USERNAME/bin/dyndnsclient.sh</string>
...
...
 17     <key>StandardErrorPath</key>
 18     <string>/Users/USERNAME/bin/dyndnsclient.sh.log</string>
 19     <key>StandardOutPath</key>
 20     <string>/Users/USERNAME/bin/dyndnsclient.sh.log</string>
...
```

* Start LaunchAgent

Copy the plist file to ~/Library/LaunchAgents/dyndns.9it.eu.plist 

```bash
cp dyndns.9it.eu.plist ~/Library/LaunchAgents/dyndns.9it.eu.plist
```

Start LaunchAgent: launchctl load ~ / Library/LaunchAgents/dyndns.9it.eu.plist

Stop LaunchAgent: launchctl unload ~ / Library/LaunchAgents/dyndns.9it.eu.plist



# <a name="todo"></a>Todo

* ~~add Setup/INIT For the first installation~~ DONE
* ~~OS-X Client (using LaunchAgent)~~ DONE 
* Add Synology NAS Support

# <a name="license"></a>License

* Read [License](https://github.com/ruedigerp/ddclient/blob/master/LICENSE.md)

