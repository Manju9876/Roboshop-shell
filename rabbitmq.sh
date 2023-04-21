script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
rabbitmq_appuser_password=$1

echo -e "\e[35m >>>>>>>>>>>>>>>>>>>>>>>>> Download the repo file <<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash

curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash

echo -e "\e[35m >>>>>>>>>>>>>>>>>>>>>>>>> install the rabbitmq & erlang <<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
yum install rabbitmq-server  erlang -y


echo -e "\e[35m >>>>>>>>>>>>>>>>>>>>>>>>> enable and start rabbitmq server<<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
systemctl enable rabbitmq-server
systemctl restart rabbitmq-server
systemctl status rabbitmq-server

echo -e "\e[35m >>>>>>>>>>>>>>>>>>>>>>>>> add user to rabbitmq<<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
rabbitmqctl add_user roboshop ${rabbitmq_appuser_password}

echo -e "\e[35m >>>>>>>>>>>>>>>>>>>>>>>>> set permisions to the user <<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"