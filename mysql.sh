script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
mysql_root_password=$1

if [ -z "$mysql_root_password" ]
then
  echo  -e "\e[36m please enter the root password \e[0m"
  exit
fi

func_print_head "disabling the default mysql version"
dnf module disable mysql -y &>>${log_file}
func_stat_check $?

func_print_head "copying the repo file"
cp  ${script_path}/mysql.repo /etc/yum.repos.d/mysql.repo &>>${log_file}
func_stat_check $?

func_print_head "installing the mysql comunity version"
yum install mysql-community-server -y &>>${log_file}
func_stat_check $?

func_print_head "start and enable mysql"
systemctl enable mysqld &>>${log_file}
systemctl restart mysqld &>>${log_file}
func_stat_check $?

func_print_head "resting the password"
mysql_secure_installation --set-root-pass ${mysql_root_password} &>>${log_file}
func_stat_check $?
