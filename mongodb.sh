echo -e "\e[35m >>>>>>>>>>>>>>>installing mongodb<<<<<<<<<<<<<<<\e[om"
echo -e "\e31m >>>>>>>>>>>>>>>>>copying the repo file <<<<<<<<<<<<<<<<<<<<\e[0m"
cp /home/centos/roboshop-shell/mongo.repo /etc/yum.repos.d/mongo.repo
echo -e "\e31m >>>>>>>>>>>>>>>>>install mongodb-org <<<<<<<<<<<<<<<<<<<<\e[0m"
yum install mongodb-org -y
echo -e "\e31m >>>>>>>>>>>>>>>>>starting and enabling the service<<<<<<<<<<<<<<<<<<<<\e[0m"
systemctl enable mongod
systemctl start mongod
echo -e "\e31m >>>>>>>>>>>>>>>>>replacing the ip address in the mongof.conf file <<<<<<<<<<<<<<<<<<<<\e[0m"
sed -i -e 's|127.0.0.1|0.0.0.0|' /etc/mongod.conf
echo -e "\e31m >>>>>>>>>>>>>>>>>restarting the service <<<<<<<<<<<<<<<<<<<<\e[0m"
systemctl restart mongod
echo -e "\e31m >>>>>>>>>>>>>>>>>checking the status of mongod<<<<<<<<<<<<<<<<<<<<\e[0m"
systemctl status mongod