
update_ip.sh will read your IP address, then connect to AWS Lightsail and update the firewall settings of each of your instances to allow access from your current public IP to these instances (on all ports!) . When  your IP address changes, it will delete the access rules of your prior IP address and open all ports for your new address.
It logs into update_ip.log inside of the working directory and stores your last IP in  last_ip.config

Preconditions: 
- aws-cli installed and configured
- on Windows: git-bash installed
- on Linux: you are fine.

You can add this to crontab or windows task schedule to check every 5 or 10 minutes for changes of your IP

get_scripts: this will fetch updates to the "update_ip" and "get_scripts" scripts. 
- Team menbers: run it once per day at time when your computer is switched on so I can send you an update to include EC2 instances as well
- If you are not part of our team: you really never ever should run scripts like that as it could be easily used to execute malicious code on your computer ;-)
