# Digital Ocean - Parse Server Setup Automation (Parse Server, Parse Dashboard, MongoDb, SSL license, HTTPS Access, NGINX HTTP Server) 

## Digital Ocean + Parse Server = Go Prototype faster

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

You will be asked couple questions along the way. Please answer truthfully :). Once you are through, you will be asked to restart the server. Once restarted, you are all DONE.


NOTE: NOT RESPONSIBLE for this code at ALL. Install and use at your own risk.


###NOT WORKING: Dashboard. (Yet) - I don't know why forever-service doesn't want to start it. My other server works with same code but now it doesn't want to start.
- You can start it by entering

```
parse-dashboard --config parse-server-config.json --allowInsecureHTTP true
```

##Everything else works.
