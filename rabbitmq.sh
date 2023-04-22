script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
rabbitmq_appuser_password=$1

if [ -z "$rabbitmq_appuser_password" ]
then
  echo input rabbitma app user passworrd is missing
  exit
fi

func_print_head "Download the repo files of rabbitmq and erlang"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash  &>>${log_file}
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>>${log_file}
func_stat_check $?

func_print_head "install the rabbitmq & erlang"
yum install rabbitmq-server  erlang -y &>>${log_file}
func_stat_check $?

func_print_head "enable and start rabbitmq server"
systemctl enable rabbitmq-server &>>${log_file}
systemctl restart rabbitmq-server &>>${log_file}
systemctl status rabbitmq-server &>>${log_file}
func_stat_check $?

func_print_head "add user to rabbitmq"
rabbitmqctl add_user roboshop ${rabbitmq_appuser_password} &>>${log_file}
func_stat_check $?

func_print_head "set permisions to the use"
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>${log_file}
func_stat_check $?