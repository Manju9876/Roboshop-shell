app_user=roboshop

script=$(realpath "$0")
script_path=$(dirname "$script")

func_print_head(){
  echo -e "\e[31m>>>>>>>>>>>>>> $1 <<<<<<<<<<<<<<<<<<<\e[0m"
}
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
   cp  ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo
   func_stat_check $?

   func_print_head "installing the mongodb client"
   yum install mongodb-org-shell -y
   func_stat_check $?

   func_print_head "loading the schema to mongodb server "
   mongo --host mongodb-dev.manju-devops.online </app/schema/user.js
   func_stat_check $?
fi

 if [ "$schema_setup" == "mysql" ]
   then
    func_print_head "installing the mysql"
     yum install mysql -y
     func_stat_check $?

     func_print_head "loading the schema  to myql DNS"
     mysql -h mysql-dev.manju-devops.online -uroot -p${mysql_root_password} < /app/schema/shipping.sql
     func_stat_check $?
 fi
}

             # This function is creeated to the prerequisite of all all common components

func_app_prereq(){

    func_print_head "creating a user "
    useradd ${app_user} >/tmp/roboshop.log

     # calling the function to check the status of the code whether  to check it is runnind succesfuly or not
      func_stat_check $?
     # end of the function

   func_print_head "creating a directory /app "
    rm -rf /app
    mkdir /app

     # calling the function to check the status of the code whether  to check it is runnind succesfuly or not
      func_stat_check $?
     # end of the function

   func_print_head "Downloading the application code "
    curl -L -o /tmp/${componet}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip

     # calling the function to check the status of the code whether  to check it is runnind succesfuly or not
      func_stat_check $?
     # end of the function

   func_print_head "unzipping the code content in /app"
   cd /app
    unzip /tmp/${component}.zip

      # calling the function to check the status of the code whether  to check it is runnind succesfuly or not
        func_stat_check $?
      # end of the function

}

func_systemd_setup(){

  func_print_head "copying the configuration file to systemd"
  cp  ${script_path}/${component}.service /etc/systemd/system/${component}.service

      # calling the function to check the status of the code whether  to check it is runnind succesfuly or not
         func_stat_check $?
      # end of the function

  func_print_head "reloading the schema"
  systemctl daemon-reload

  func_print_head "starting and enabling the schema & viewing the status of the service "
  systemctl enable ${component}
  systemctl restart ${component}
  systemctl status ${component}

    # calling the function to check the status of the code whether  to check it is runnind succesfuly or not
       func_stat_check $?
    # end of the function

}

                         # This nodejs function is called in "CATALOGU, USER, CART"

func_nodejs() {

 func_print_head "Downloading the nodejs js repo file"
 curl -sL https://rpm.nodesource.com/setup_lts.x | bash

    # calling the function to check the status of the code whether  to check it is runnind succesfuly or not
        func_stat_check $?
    # end of the function

 func_app_prereq "install node js"
  yum install nodejs -y >/tmp/roboshop.log

    # calling the function to check the status of the code whether  to check it is runnind succesfuly or not
     func_stat_check $?
    # end of the function

    # calling a function  func_app_prereq
     func_app_prereq
    # end of the function

 func_print_head "installing the dependencies"
  npm install

  # calling the schema_setup
  func_schema_setup
    #end of the function

  # calling the systemd configurations function
 func_systemd_setup
   # end of the function

}


                                     # This function is called in "SHIPPING"

func_java(){

  func_print_head "install maven "
  yum install maven -y >/tmp/roboshop.log

   # calling the function to check the status of the code whether  to check it is runnind succesfuly or not
    func_stat_check $?
   # end of the function

   # calling a function  func_app_prereq
    func_app_prereq
   # end of the function

   func_print_head "downloading the dependincies"
     mvn clean package

   # calling the function to check the status of the code whether  to check it is runnind succesfuly or not
    func_stat_check $?
   # end of the function

     mv target/${component}-1.0.jar ${component}.jar

   # callinf the schema setup function
    func_schema_setup
   # end of the function

   # calling the systemd configurations function
    func_systemd_setup
   # end of the function

}