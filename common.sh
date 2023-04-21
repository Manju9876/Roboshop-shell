app_user=roboshop

script=$(realpath "$0")
script_path=$(dirname "$script")

print_head(){
  echo -e "\e[31m>>>>>>>>>>>>>> $1 <<<<<<<<<<<<<<<<<<<\e[0m"
}

func_nodejs() {

print_head "download the repo file"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash

print_head "install node js "
yum install nodejs -y

print_head "crate a user "
useradd ${app_user}

print_head "crate app directory"
rm -rf /app
mkdir /app

print_head "downloading and unzipping the content tp /app directory"
curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip
cd /app
unzip /tmp/${component}.zip

print_head "installing the dependencies"
npm install

print_head "copying the configuration file to systemd"
cp  ${script_path}/${component}.service /etc/systemd/system/${component}.service

print_head "reloading the schema"
systemctl daemon-reload

print_head "starting and enabling the schema"
systemctl enable ${component}
systemctl start ${component}

print_head "checking the status of cart service "
systemctl status ${component}

}