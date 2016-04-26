sudo cat /etc/letsencrypt/archive/$domain/{fullchain1.pem,privkey1.pem} | sudo tee /etc/ssl/mongo.pem
sudo chown mongodb:mongodb /etc/ssl/mongo.pem
sudo chmod 600 /etc/ssl/mongo.pem