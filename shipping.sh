
script_path=$(dirname $0)
source ${script_path}/common.sh
echo ${app_user}
exit

echo -e "\e[34m >>>>>>>>>>>>>>>>>>>>>>>>>>>> installing maven <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
yum install maven -y

echo -e "\e[34m >>>>>>>>>>>>>>>>>>>>>>>>>>>> creating a user <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
useradd ${app_user}

echo -e "\e[34m >>>>>>>>>>>>>>>>>>>>>>>>>>>> creating a directory /app <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
mkdir /app

echo -e "\e[34m >>>>>>>>>>>>>>>>>>>>>>>>>>>> Downloading the application code <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping.zip

echo -e "\e[34m >>>>>>>>>>>>>>>>>>>>>>>>>>>> Changing the directory <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
cd /app

echo -e "\e[34m >>>>>>>>>>>>>>>>>>>>>>>>>>>> unzipping the code content in /app<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
unzip /tmp/shipping.zip

echo -e "\e[34m >>>>>>>>>>>>>>>>>>>>>>>>>>>> downloading the dependincies<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
mvn clean package
mv target/shipping-1.0.jar shipping.jar

echo -e "\e[34m >>>>>>>>>>>>>>>>>>>>>>>>>>>> copying the configuration file to systemd <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
cp /home/centos/roboshop-shell/shipping.service /etc/systemd/system/shipping.service

echo -e "\e[34m >>>>>>>>>>>>>>>>>>>>>>>>>>>> reloading the systemd<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
systemctl daemon-reload

echo -e "\e[34m >>>>>>>>>>>>>>>>>>>>>>>>>>>> restarting and enblig the shipping <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
systemctl enable shipping
systemctl start shipping

echo -e "\e[34m >>>>>>>>>>>>>>>>>>>>>>>>>>>> installing the mysql <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
yum install mysql -y

echo -e "\e[34m >>>>>>>>>>>>>>>>>>>>>>>>>>>> loading the schema  to myql DNS<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
mysql -h mysql-dev.manju-devops.online -uroot -pRoboShop@1 < /app/schema/shipping.sql

echo -e "\e[34m >>>>>>>>>>>>>>>>>>>>>>>>>>>> restarting and cheking the status of shipping <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
systemctl restart shipping
systemctl status shipping