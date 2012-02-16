##Intro
This is a Bugzilla extension that is used to post bug notifications to 
[grove.io][2] IRC channels, using their RESTful [service integration][3]. 
The notifications currently produce IRC messages on newly created bugs 
and updates to existing bugs. 

## Installation
The extension requires the [REST::Client][1] module. You can usually install that 
through Bugzilla's install-module.pl script (shown below).

Find the Bugzilla directory of your distribution:
   
* `cd bugzilla`
* `git clone git://github.com/saadware/BugzillaNotifyGrove.git extensions/NotifyGrove` 
* `./install-module.pl REST::Client`
* Open a web browser and go the Bugzilla Parameter Administration page.
* Click the new panel on the left side named **Notify Grove Extension**.
* At the very minimum, fill in the **grove_url** parameter to be the channel 
specific url provided by grove.io. It resembles something like:
`https://grove.io/api/notice/somereallylongstringgoeshere/`
* Optionally you can fill out the rest of the parameters.

[1]: http://search.cpan.org/~mcrawfor/REST-Client-88/lib/REST/Client.pm
[2]: http://grove.io
[3]: https://grove.io/help/tools/service-integrations