script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

echo -e "\e[32m>>>>>>>>>>>>>>>>>>>>>>>>>>> downloading repo file for redis <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y

echo -e "\e[32m>>>>>>>>>>>>>>>>>>>>>>>>>>> enabling the redis 6.2 version <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
dnf module enable redis:remi-6.2 -y

echo -e "\e[32m>>>>>>>>>>>>>>>>>>>>>>>>>>> installing the redis software <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
yum install redis -y

echo -e "\e[32m>>>>>>>>>>>>>>>>>>>>>>>>>>> replacing the IP address to listen to 0.0.0.0 <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
sed -i -e 's|127.0.0.1|0.0.0.0|' /etc/redis.conf /etc/redis/redis.conf

echo -e "\e[32m>>>>>>>>>>>>>>>>>>>>>>>>>>> starting and enabling the redis service <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
systemctl enable redis
systemctl start redis

echo -e "\e[32m>>>>>>>>>>>>>>>>>>>>>>>>>>> restart redis and check the status of redis <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
systemctl restart redis
systemctl status redis

echo -e "\e[32m>>>>>>>>>>>>>>>>>>>>>>>>>>> check the server of redis is listen to 'all'  <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
netstat -lntp
