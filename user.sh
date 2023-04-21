script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

component=user

func_nodejs

echo -e "\e[32m>>>>>>>>>>>>>> copying the repo file of mongodb to yum.repos.d <<<<<<<<<<<<<<<<<<<\e[0m"
cp  ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo

echo -e "\e[32m>>>>>>>>>>>>>> installing the mongodb client<<<<<<<<<<<<<<<<<<<\e[0m"
yum install mongodb-org-shell -y

echo -e "\e[32m>>>>>>>>>>>>>> loading the schema to mongodb server <<<<<<<<<<<<<<<<<<<\e[0m"
mongo --host mongodb-dev.manju-devops.online </app/schema/user.js
