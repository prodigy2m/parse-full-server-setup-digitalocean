# Instructions
# sudo apt-get update
# sudo apt-get install git -y
# git clone https://github.com/prodigy2m/parse-full-server-setup-digitalocean.git
# sh parse-full-server-setup-digitalocean/parse-setup.sh
# Done

# Start updating server to up-to-date

echo "------------------------------------------------------------------"
echo "################# Starting Step-by-Step  #########################"
echo "------------------------------------------------------------------"

echo "------------------------------------------------------------------"
echo "####################### REQUIREMENTS  ############################"
echo " ---- DOMAIN NAME - DIGITAL OCEAN ACCOUNT - At least $5 Plan -----"
echo "------------------------------------------------------------------"

echo "------------------------------------------------------------------"
echo "########################## AGREEMENT  ############################"
echo " I take no responsibilities on any of my code, or what happens after you run this script. Good Luck!"
echo "------------------------------------------------------------------"

echo -p "Do you have everything you need to start? (y/n)?"
	read choice
	
	case $choice in
		y)

			clear
			sudo apt-get -y upgrade
			sudo apt-get -y update

			echo "------------------------------------------------------------------"
			echo "######################### SWAP SETUP $5 Server  ##################"
			echo "------------------------------------------------------------------"
			echo "This section is for creating SWAP memory for smallest servers in DigitalOcean"

			echo -p "Are you using the CHEAPEST DigitalOcean Plan? (y/n)? "
				read choice
				case $choice in
					y)	
						echo "Creating SWAP memory"
						sudo fallocate -l 4G /swapfile
						ls -lh /swapfile
						sudo chmod 600 /swapfile
						ls -lh /swapfile
						sudo mkswap /swapfile
						sudo swapon /swapfile
						# check if swap created
						free -m 
						echo "Your SWAP Memory was increased. Good luck in next steps"
					;;
					n)
						echo "Continue without SWAP changes";
					;;
				esac

			sleep 2

			# echo "- Installing GIThub. -"
			# sleep 1
			# sudo apt-get -y install git bc

			echo "- Installing Node Essential. -"
			sleep 1
			curl -sL https://deb.nodesource.com/setup_5.x -o nodesource_setup.sh
			sudo -E bash ./nodesource_setup.sh
			sudo apt-get -y install nodejs build-essential git

			echo "- Installing Express. -"
			sleep 1
			npm install -g express
			~/.nvm/node_version/lib/node_modules/package_name
			npm link express

			echo "- Installing NGINX Server. -"
			sleep 1
			sudo apt-get -y install nginx
			sudo service nginx stop

			echo "- Installing SSL Licence. -"
			sleep 1
			sudo git clone https://github.com/letsencrypt/letsencrypt /opt/letsencrypt
			cd /opt/letsencrypt
			./letsencrypt-auto certonly --standalone

			echo "- Installing MongoDb Org. -"
			sleep 1
			sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
			echo "deb http://repo.mongodb.org/apt/ubuntu "$(lsb_release -sc)"/mongodb-org/3.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.0.list
			sudo apt-get -y update
			sudo apt-get -y install mongodb-org
			service mongod status

			echo " ############### MONGO STATUS #################"
			sleep 5

			echo "- Porting NGINX and MongoDb SSL Licence. -"
			sleep 1
			sudo cat /etc/letsencrypt/archive/$input/{fullchain1.pem,privkey1.pem} | sudo tee /etc/ssl/mongo.pem
			sudo chown mongodb:mongodb /etc/ssl/mongo.pem
			sudo chmod 600 /etc/ssl/mongo.pem
			# mongo --port 27017

			echo "- Starting NGINX. -"
			sleep 1
			sudo service nginx restart

			echo "- Installing Parse Server (Example) -"
			sleep 1			
			git clone https://github.com/ParsePlatform/parse-server-example.git
			cd parse-server-example
			npm install

			echo "- Installing Parse Dashboard -"
			sleep 1	
			cd ~/root/parse-server-example
			cd ..
			git clone https://github.com/ParsePlatform/parse-dashboard.git
			cd parse-dashboard
			npm install -g parse-dashboard

			echo "- Installing Forever for Running Production -"
			sleep 1			
			sudo apt-get -y install forever


			echo " ########### CONGFIGURATION PROCESS #############"

			sleep 1

			echo "You must have DOMAIN name assigned to this server for it to work."
			echo -p "Do you have DOMAIN name assigned to this server? (y/n)?"
				read choice
				
				case $choice in
				y)
					echo "Enter your domain name (Without http, or www): "
						read input

					domain=$input
					sed 's/domain/'"$input"'/g' default_sample > /etc/nginx/sites-available/default
					service nginx restart
					echo "Your SSH for nginx is all setup and done."
				;;
				n)
				  echo "Please assign a DOMAIN name for this server to work and re-run this script again";
				;;
			esac			

			echo "- Configuring Autostart for Parse Server & Livequery & Parse Dashboard -"
			sleep 2			
			echo -en "start on startup\nexec forever start /root/parse-server-example/index.js" > /etc/init/parse.conf
			echo -en "start on startup\nexec forever start /root/parse-dashboard/Parse-Dashboard/index.js --allowInsecureHTTP true" > /etc/init/parse-dashboard.conf

			echo "- Generating Unique Master & Client Keys -"
			sleep 2
			# Generate 20 Alpha/NumericalCaseSensative ID's
			NEW_ID_MASTER=$(cat /dev/urandom | tr -dc "a-zA-Z0-9" | fold -w 20 | head -n 1)
			NEW_ID_CLIENT=$(cat /dev/urandom | tr -dc "a-zA-Z0-9" | fold -w 20 | head -n 1)

			echo "- Creating First MongoDb Entry -"
			sleep 2			
			curl -X POST \
				-H "X-Parse-Application-Id: $NEW_ID_CLIENT" \
				-H "Content-Type: application/json" \
				-d '{"score":1337,"playerName":"Sammy","cheatMode":false}' \
				http://$input:1337/parse/classes/GameScore

			sleep 2

			# Creating new user name and password for Parse Dashboard Login. 
			echo "############### IMPORTANT  #######################"
			echo "--- Please create your new User name and Password "
			echo "--------------------------------------------------"
			echo ""
			echo "Parse User Name (Case sensative):  "
			read user
			echo "Parse Password (Case sensative):  "
			read pass
			sleep 1
			sed 's/masterid/'"$NEW_ID_MASTER"'/g; s/appid/'"$NEW_ID_CLIENT"'/g; s/domain/'"$input"'/g; s/user/'"$user"'/g; s/pass/'"$pass"'/g' parse-dashboard-config.json > /root/parse-dashboard/Parse-Dashboard/parse-dashboard-config.json

			# Embed new Generated ID's to Index.js file for Parse Server
			sed 's/masterid/'"$NEW_ID_MASTER"'/g; s/appid/'"$NEW_ID_CLIENT"'/g' parse_app_setup.js > /root/parse-server-example/index.js

			echo "------------------------------------------------------------------"
			echo "$############# IMPORTANT - WRITE THIS DOWN  ######################"
			echo " ---- MASTER KEY (Keep this private): $NEW_ID_MASTER"
			echo " ---- CLIENT KEY: $NEW_ID_CLIENT"
			echo ""
			echo " ----------------------- LOCATIONS -------------------------------"
			echo " - Parse Dashboard: http://$input:4040 - Sorry still can't get HTTPS to work"
			echo " - Parse Server: https://$input/parse"
			echo " - Parse LiveQuery Server: ws://$input:1337"
			echo ""
			echo "$################ GOOD LUCK BUILDING STUFF  ######################"  
			echo "------------------------------------------------------------------"

			sleep 5

			echo -p "Do you have everything you need to start? (y/n)?"
				read restart_this
	
				case $choice in
					y)
						echo "Rebooting now";
						reboot
						;;
					n)
						echo "- Some services might not work if you don't restart the server -"
						;;
				esac

			;;
		n)
			echo "------------------------------------------------------------------"
			echo "- You can restart this script once you have everything prepared. -"
			echo "------------------------------------------------------------------"
			;;
	esac
