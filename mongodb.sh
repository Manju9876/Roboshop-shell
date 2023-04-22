script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

component="mongod"
service_start="mongodb"

 func_print_head " downloading repo file and installing mongodb"
   cp  ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo  &>>${log_file}
   yum install mongodb-org -y  &>>${log_file}
   func_stat_check $?

func_print_head "updating the mongod.conf file to 0.0.0.0"
   sed -i -e 's|127.0.0.1|0.0.0.0|' /etc/mongod.conf &>>${log_file}
   func_stat_check $?

func_print_head "start service of mongodb"
systemctl enable mongod &>>${log_file}
systemctl restart mongod &>>${log_file}
systemctl status mongod &>>${log_file}
func_stat_check $?
