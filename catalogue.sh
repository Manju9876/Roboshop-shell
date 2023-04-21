script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

echo -e "\e[32m>>>>>>>>>>>>>> configuration of node js<<<<<<<<<<<<<<<<<<<\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash

echo -e "\e[32m>>>>>>>>>>>>>> install of node js<<<<<<<<<<<<<<<<<<<\e[0m"
yum install nodejs -y

echo -e "\e[32m>>>>>>>>>>>>>> starting and enabling node js <<<<<<<<<<<<<<<<<<<\e[0m"
systemctl start catalogue
systemctl enable catalogue

echo -e "\e[32m>>>>>>>>>>>>>> creating a user <<<<<<<<<<<<<<<<<<<\e[0m"
useradd ${app_user}

echo -e "\e[32m>>>>>>>>>>>>>> creating a directory <<<<<<<<<<<<<<<<<<<\e[0m"
rm -rf /app
mkdir /app

echo -e "\e[32m>>>>>>>>>>>>>> dowloading code<<<<<<<<<<<<<<<<<<<\e[0m"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip

echo -e "\e[32m>>>>>>>>>>>>>> changed directory <<<<<<<<<<<<<<<<<<<\e[0m"
cd /app

echo -e "\e[32m>>>>>>>>>>>>>> unziped the content we downloaded <<<<<<<<<<<<<<<<<<<\e[0m"
unzip /tmp/catalogue.zip

echo -e "\e[32m>>>>>>>>>>>>>> installing the dependencies<<<<<<<<<<<<<<<<<<<\e[0m"
npm install

echo -e "\e[32m>>>>>>>>>>>>>> copying the configuration file to the systemd <<<<<<<<<<<<<<<<<<<\e[0m"
cp  ${script_path}/catalogue.service  /etc/systemd/system/catalogue.service

echo -e "\e[32m>>>>>>>>>>>>>> reloading the service in systemd <<<<<<<<<<<<<<<<<<<\e[0m"
systemctl daemon-reload

echo -e "\e[32m>>>>>>>>>>>>>> restarting the service in systemd <<<<<<<<<<<<<<<<<<<\e[0m"
systemctl restart catalogue

echo -e "\e[32m>>>>>>>>>>>>>> copying the mongodb repo file <<<<<<<<<<<<<<<<<<<\e[0m"
cp  ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo

echo -e "\e[32m>>>>>>>>>>>>>> installing the mongodb client <<<<<<<<<<<<<<<<<<<\e[0m"
yum install mongodb-org-shell -y

echo -e "\e[32m>>>>>>>>>>>>>> loading the schema <<<<<<<<<<<<<<<<<<<\e[0m"
mongo --host mongodb-dev.manju-devops.online </app/schema/catalogue.js
