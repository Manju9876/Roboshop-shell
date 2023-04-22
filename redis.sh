script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

func_print_head " downloading repo file for redis"
yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y  &>>${log_file}
func_stat_check $?


func_print_head "enabling the redis 6.2 version"
dnf module enable redis:remi-6.2 -y &>>${log_file}
 func_stat_check $?

func_print_head "installing the redis software"
yum install redis -y &>>${log_file}
 func_stat_check $?

func_print_head "replacing the IP address to listen to 0.0.0.0"
sed -i -e 's|127.0.0.1|0.0.0.0|' /etc/redis.conf /etc/redis/redis.conf &>>${log_file}
 func_stat_check $?

func_print_head "start service and checking the status of service and connectivity "
systemctl enable redis &>>${log_file}
systemctl restart redis &>>${log_file}
systemctl status redis &>>${log_file}
func_stat_check $?
