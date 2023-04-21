script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
rabbitmq_appuser_password=$1

if [ -z "$rabbitmq_appuser_password" ]
then
  echo input missing for app user password fo rabbitmq
  exit
fi
echo -e "\e[31m >>>>>>>>>>>>>>>>>>>>>>>>>>>>>> installing the python36<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
yum install python36 gcc python3-devel -y

echo -e "\e[31m >>>>>>>>>>>>>>>>>>>>>>>>>>>>>> create a user <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
useradd ${app_user}

echo -e "\e[31m >>>>>>>>>>>>>>>>>>>>>>>>>>>>>> create a directory <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
rm -rf /app
mkdir /app

echo -e "\e[31m >>>>>>>>>>>>>>>>>>>>>>>>>>>>>> download the code content <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
curl -L -o /tmp/payment.zip https://roboshop-artifacts.s3.amazonaws.com/payment.zip

echo -e "\e[31m >>>>>>>>>>>>>>>>>>>>>>>>>>>>>> change directory and unzip the code <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
cd /app
unzip /tmp/payment.zip

echo -e "\e[31m >>>>>>>>>>>>>>>>>>>>>>>>>>>>>> installing the dependencies  <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
pip3.6 install -r requirements.txt

echo -e "\e[31m >>>>>>>>>>>>>>>>>>>>>>>>>>>>>> copying the service file to systemd <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
sed -i -e "s|rabbitmq_appuser_password|${rabbitmq_appuser_password}|" ${script_path}/payment.service
cp  ${script_path}/payment.service /etc/systemd/system/payment.service

echo -e "\e[31m >>>>>>>>>>>>>>>>>>>>>>>>>>>>>> reloading the systemd <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
systemctl daemon-reload

echo -e "\e[31m >>>>>>>>>>>>>>>>>>>>>>>>>>>>>> enablig and restarting the service <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
systemctl enable payment
systemctl restart payment

echo -e "\e[31m >>>>>>>>>>>>>>>>>>>>>>>>>>>>>> checking the status of the payemnt service <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
systemctl status payment