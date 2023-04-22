script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

component="mongod"
service_start="mongodb"

 func_print_head "copying the repo file of mongodb to yum.repos.d "
   cp  ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo &>>${log_file}
   func_stat_check $?

 func_print_head " downloading repo file and installing mongodb"
   cp  ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo
   yum install mongodb-org -y  &>>${log_file}
   func_stat_check $?

func_print_head "updating the mongod.conf file to 0.0.0.0"
   sed -i -e 's|127.0.0.1|0.0.0.0|' /etc/mongod.conf &>>${log_file}

   service_start