script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
mysql_root_password=$1

if [ -z "$mysql_root_password" ]
then
  echo  -e "\e[34m please enter the root password \e[0m"
  exit
fi
echo -e "\e[31m >>>>>>>>>>>>>>>>>>>>>>>>> installing mysql <<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
echo -e "\e[31m >>>>>>>>>>>>>>>>>>>>>>>>> diableing the mysql default version <<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
dnf module disable mysql -y

echo -e "\e[31m >>>>>>>>>>>>>>>>>>>>>>>>> copying the repo file  <<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
cp  ${script_path}/mysql.repo /etc/yum.repos.d/mysql.repo

echo -e "\e[31m >>>>>>>>>>>>>>>>>>>>>>>>> installign the mysql community verison <<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
yum install mysql-community-server -y

echo -e "\e[31m >>>>>>>>>>>>>>>>>>>>>>>>> enabling and starting the mysql  <<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
systemctl enable mysqld
systemctl start mysqld

echo -e "\e[31m >>>>>>>>>>>>>>>>>>>>>>>>>reset  mysql passwd <<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
mysql_secure_installation --set-root-pass ${mysql_root_password}

echo -e "\e[31m >>>>>>>>>>>>>>>>>>>>>>>>> checking the new passwd is working are not  <<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
mysql -uroot -p${mysql_root_password}