## Introduction
This is a Bugzilla extension that is used to post bug notifications to 
grove.io IRC channels, using their RESTful [service integration](https://grove.io/help/tools/service-integrations). 
The notifications currently produce new IRC messages on newly created bugs 
and updates to existing bugs. 

## Installation
The extension requires the REST::Client module. You can usually install that 
through Bugzilla's install-module.pl script (shown below).

Find the Bugzilla directory of your distribution:
* cd bugzilla
* git clone https://github.com/saadware/BugzillaNotifyGrove extensions/NotifyGrove 
* ./install-module.pl REST::Client
* Open a web browser and go the Bugzilla Parameter Administration page.
* Click the new panel on the left side named **Notify Grove Extension**.
* At the very minimum, fill in the **grove_url** parameter to be the channel 
specific url provided by grove.io. It resembles something like:
https://grove.io/api/notice/somereallylongstringgoeshere/
* Optionally you can fill out the rest of the parameters.
