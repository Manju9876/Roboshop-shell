script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
rabbitmq_appuser_password=$1

if [ -z "$rabbitmq_appuser_password" ]
then
  echo -e "\e[36m please enter the rabbitmq appuser password\e[0m"
  exit
fi
component="payment"
func_python