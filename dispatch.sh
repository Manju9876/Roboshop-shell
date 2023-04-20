
echo -e "\e[36m >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> install golang<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
yum install golang -y

echo -e "\e[36m >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> create user <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
useradd roboshop

echo -e "\e[36m >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> create a directory <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
mkdir /app

echo -e "\e[36m >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> download the code content  <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
curl -L -o /tmp/dispatch.zip https://roboshop-artifacts.s3.amazonaws.com/dispatch.zip

echo -e "\e[36m >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> change directory and extract the code <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
cd /app
unzip /tmp/dispatch.zip

echo -e "\e[36m >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> install the dependencies  <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
go mod init dispatch
go get
go build

echo -e "\e[36m >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> copy the serice file to systemd <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
cp /home/centos/roboshop-shell/dispatch.service /etc/systemd/system/dispatch.service

echo -e "\e[36m >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> relaod the systemd  <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
systemctl daemon-reload

echo -e "\e[36m >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> enable and start the service  <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
systemctl enable dispatch
systemctl restart dispatch

echo -e "\e[36m >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> checking the status of the service  <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
systemctl status dispatch