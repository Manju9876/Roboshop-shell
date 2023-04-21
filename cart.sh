
script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

echo script_path is ${script_path}
exit


echo -e "\e[32m>>>>>>>>>>>>>> download the repo file  <<<<<<<<<<<<<<<<<<<\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash

echo -e "\e[32m>>>>>>>>>>>>>> install node js  <<<<<<<<<<<<<<<<<<<\e[0m"
yum install nodejs -y

echo -e "\e[32m>>>>>>>>>>>>>> crate a user  <<<<<<<<<<<<<<<<<<<\e[0m"
useradd ${app_user}

echo -e "\e[32m>>>>>>>>>>>>>> crate app directory <<<<<<<<<<<<<<<<<<<\e[0m"
rm -rf /app
mkdir /app

echo -e "\e[32m>>>>>>>>>>>>>> downloading and unzipping the content tp /app directory <<<<<<<<<<<<<<<<<<<\e[0m"
curl -L -o /tmp/cart.zip https://roboshop-artifacts.s3.amazonaws.com/cart.zip
cd /app
unzip /tmp/cart.zip

echo -e "\e[32m>>>>>>>>>>>>>> installing the dependencies  <<<<<<<<<<<<<<<<<<<\e[0m"
npm install

echo -e "\e[32m>>>>>>>>>>>>>> copying the configuration file to systemd <<<<<<<<<<<<<<<<<<<\e[0m"
cp  ${script_path}/cart.service /etc/systemd/system/cart.service

echo -e "\e[32m>>>>>>>>>>>>>> reloading the schema <<<<<<<<<<<<<<<<<<<\e[0m"
systemctl daemon-reload

echo -e "\e[32m>>>>>>>>>>>>>> starting and enabling the schema <<<<<<<<<<<<<<<<<<<\e[0m"
systemctl enable cart
systemctl start cart

echo -e "\e[32m>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> checking the status of cart service <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
systemctl status cart