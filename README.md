# cert-check

This script can be used to check your domain ssl certificate expiration time and let you now if you've already implemented a messaging system (such as Rocket.chat,mattermost,...).

To use this script you should just run it by bash but before running make sure to set some variables based on your environment.

Put your domain name in 'domain' variable and also set webhook and token based on your messaging system.

After running this script it will create a json file which contains domain-name,start-date and expire-date and then tries to send it to your channel.
