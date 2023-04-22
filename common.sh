app_user=roboshop
script=$(realpath "$0")
script_path=$(dirname "$script")
log_file=/tmp/roboshop.log
#rm -f /tmp/roboshop.log
                              # this functions prints the heading of each command
func_print_head(){
  echo -e "\e[31m>>>>>>>>>>>>>> $1 <<<<<<<<<<<<<<<<<<<\e[0m"
  echo -e "\e[31m>>>>>>>>>>>>>> $1 <<<<<<<<<<<<<<<<<<<\e[0m" &>>${log_file}
}

                          # This command  checks the staus of  each command Success/Failure
func_stat_check(){

        if [ "$1" -eq 0 ]
              then
                echo -e "\e[32m SUCCESS \e[0m"
               else
                echo -e "\e[31m FAILED \e[0m"
                echo "please refer the /tmp/roboshop.log for more information"
               exit 1
         fi
}
                                 # This function created to loaad the schema
func_schema_setup(){
if [ "$schema_setup" == "mongo" ]
 then
   func_print_head "copying the repo file of mongodb to yum.repos.d "
   cp  ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo &>>${log_file}
   func_stat_check $?

   func_print_head "installing the mongodb client"
   yum install mongodb-org-shell -y &>>${log_file}
   func_stat_check $?

   func_print_head "loading the schema to mongodb server "
   mongo --host mongodb-dev.manju-devops.online </app/schema/user.js &>>${log_file}
   func_stat_check $?
fi

 if [ "$schema_setup" == "mysql" ]
   then
    func_print_head "installing the mysql"
     yum install mysql -y &>>${log_file}
     func_stat_check $?

     func_print_head "loading the schema  to myql DNS"
     mysql -h mysql-dev.manju-devops.online -uroot -p${mysql_root_password} < /app/schema/shipping.sql &>>${log_file}
     func_stat_check $?
 fi
}

             # This function is creeated to the prerequisite of all all common components

func_app_prereq(){

    func_print_head "creating a user "
     id ${app_user} &>>${log_file}
     if [ $? -ne 0 ]
      then
        useradd ${app_user} &>>${log_file}
     fi
    func_stat_check $?

    func_print_head "creating a directory /app "
     rm -rf /app &>>${log_file}
     mkdir /app  &>>${log_file}
    func_stat_check $?

    func_print_head "Downloading the application code "
     curl -L -o /tmp/${componet}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>${log_file}
    func_stat_check $?

    func_print_head "unzipping the code content in /app"
     cd /app
     unzip /tmp/${component}.zip &>>${log_file}
     func_stat_check $?

}

func_systemd_setup(){

  func_print_head "copying the configuration file to systemd"
  cp  ${script_path}/${component}.service /etc/systemd/system/${component}.service &>>${log_file}
  func_stat_check $?
      
  func_print_head "reloading the schema"
  systemctl daemon-reload &>>${log_file}

  func_print_head "starting and enabling the schema checking  the status of the service "
  systemctl enable ${component} &>>${log_file}
  systemctl restart ${component} &>>${log_file}
  systemctl status ${component} &>>${log_file}
  func_stat_check $?
 if [ "$service_start" == "mongodb" ]
  then
    systemctl enable ${component} &>>${log_file}
      systemctl restart ${component} &>>${log_file}
      systemctl status ${component} &>>${log_file}
 fi
}

                         # This nodejs function is called in "CATALOGU, USER, CART"

func_nodejs() {

 func_print_head "Downloading the nodejs js repo file"
 curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log_file}
 func_stat_check $?

 func_print_head "Install NodeJS"
 yum install nodejs -y &>>${log_file}
 func_stat_check $?

 func_app_prereq

 func_print_head "installing the dependencies"
 npm install &>>${log_file}

 func_schema_setup
 func_systemd_setup

}


                                     # This function is called in "SHIPPING"

func_java(){

  func_print_head "install maven "
  yum install maven -y &>>${log_file}

  func_stat_check $?
  func_app_prereq

  func_print_head "downloading the dependincies"
  mvn clean package &>>${log_file}
  func_stat_check $?

  mv target/${component}-1.0.jar ${component}.jar &>>${log_file}

  func_schema_setup
  func_systemd_setup

}

func_python(){
  func_print_head "installing python 36 version"
  yum install python36 gcc python3-devel -y &>>${log_file}
  func_stat_check $?

  func_app_prereq

  func_print_head "installing the dependencies"
  pip3.6 install -r requirements.txt &>>${log_file}
  func_stat_check $?

  func_print_head "copying the service file to systemd and updateing the passowrd in service file"
  sed -i -e "s|rabbitmq_appuser_password|${rabbitmq_appuser_password}|" ${script_path}/payment.service
  func_stat_check $?

  func_systemd_setup

}

func_golang(){
  func_print_head "install golang"
  yum install golang -y &>>${log_file}
  func_stat_check $?

  func_app_prereq

  func_print_head "install golang dependencies"
  go mod init dispatch &>>${log_file}
  go get &>>${log_file}
  go build &>>${log_file}

  func_stat_check $?

  func_systemd_setup
}