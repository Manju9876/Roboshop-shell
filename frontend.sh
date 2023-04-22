script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh



func_print_head "installing nginx"
yum install nginx -y &>>${log_file}
func_stat_check $?

func_print_head "copying the service file to systemd"
cp  ${script_path}/roboshop.conf /etc/nginx/default.d/roboshop.conf &>>${log_file}
func_stat_check $?

func_print_head "removing the old files"
rm -rf /usr/share/nginx/html/* &>>${log_file}
func_stat_check $?

func_print_head "downloading the application code"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>${log_file}
func_stat_check $?

func_print_head "unziping the content"
cd /usr/share/nginx/html &>>${log_file}
unzip /tmp/frontend.zip &>>${log_file}
func_stat_check $?

func_print_head "restaring the nginx and checking the status"
systemctl enable nginx &>>${log_file}
systemctl restart nginx &>>${log_file}
systemctl status nginx &>>${log_file}
func_stat_check $?
