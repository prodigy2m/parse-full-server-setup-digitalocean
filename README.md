# Digital Ocean - Parse Server Setup Automation (Parse Server, Parse Dashboard, MongoDb, SSL license, HTTPS Access, NGINX HTTP Server)

###Parse Server
- Parse Details: https://parse.com/
- Parse GitHub: https://parseplatform.github.io/

## Digital Ocean + Parse Server =  Creativity

Works with smallest Digital Ocean plans. You need to follow the instructions. Simple steps.

### Prerequisites

- Must have a minimum $5 dollar server activated from Digital Ocean (Visit: http://digitalocean.com)
- Must have domain associated to that server

### Instructions

```
sudo apt-get update
sudo apt-get -y install git bc
git clone https://github.com/prodigy2m/parse-full-server-setup-digitalocean.git
sh parse-full-server-setup-digitalocean/parse-setup.sh
```

### What you get with this install
- Parse Server (SSL only access)
- Parse Dashboard
- Mongo Db (No direct access (Security issue))
- NGINX (SSL Web Server Only - More secure) - Folder to access files /usr/share/nginx/www/"your-domain"
- SSL License with HTTPS Access ONLY

You will be asked couple questions along the way. Please answer truthfully :). Once you are through, you will be asked to restart the server. Once restarted, you are all DONE.


NOTE: NOT RESPONSIBLE for this code at ALL. Install and use at your own risk.
