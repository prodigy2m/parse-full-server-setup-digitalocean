			echo "You must have DOMAIN name assigned to this server for it to work."
			echo -p "Do you have DOMAIN name assigned to this server? (y/n)?"
				read choice
				
				case $choice in
				y)
					echo "Enter your domain name (Without http, or www): "
						read input

					domain=$input
					sed 's/domain/'"$input"'/g' /root/parse-full-server-setup-digitalocean/default_sample > /etc/nginx/sites-available/default
					echo "Your SSH for nginx is all setup and done."
					sleep 2
				;;
				n)
				  echo "Please assign a DOMAIN name for this server to work and re-run this script again";
				;;
			esac

			echo "- Porting NGINX and MongoDb SSL Licence. -"
			sleep 1
			sudo cat /etc/letsencrypt/archive/$input/{fullchain1.pem,privkey1.pem} | sudo tee /etc/ssl/mongo.pem
			sudo chown mongodb:mongodb /etc/ssl/mongo.pem
			sudo chmod 600 /etc/ssl/mongo.pem

			echo "- Starting NGINX. -"
			sleep 1
			sudo service nginx restart


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
			sed 's/masterid/'"$NEW_ID_MASTER"'/g; s/appid/'"$NEW_ID_CLIENT"'/g; s/domain/'"$input"'/g; s/user/'"$user"'/g; s/pass/'"$pass"'/g' /root/parse-full-server-setup-digitalocean/parse-dashboard-config.json > /root/parse-dashboard/Parse-Dashboard/parse-dashboard-config.json

			# Embed new Generated ID's to Index.js file for Parse Server
			sed 's/masterid/'"$NEW_ID_MASTER"'/g; s/appid/'"$NEW_ID_CLIENT"'/g' /root/parse-full-server-setup-digitalocean/parse_app_setup.js > /root/parse-server-example/index.js

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