echo -e "\e[31m >>>>>>>>>>>>>>>>>installing nginx<<<<<<<<<<<<<<<<<<<<\e[0m"
yum install nginx -y
echo -e "\e[31m>>>>>>>>>>>>>> starting and enabling the nginx service <<<<<<<<<<<<<<<<<<<\e[0m"
systemctl enable nginx
systemctl start nginx
echo -e "\e[31m >>>>>>>>>>>>>>>>>remving the existing content in nginx<<<<<<<<<<<<<<<<<<<<\e[0m"
rm -rf /usr/share/nginx/html/*
echo -e "\e[31m >>>>>>>>>>>>>>>>>downloadig the  application code <<<<<<<<<<<<<<<<<<<<\e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip
echo -e "\e[31m >>>>>>>>>>>>>>>>>changing the directory and unzip the downloaded code <<<<<<<<<<<<<<<<<<<<\e[0m"
cd /usr/share/nginx/html
unzip /tmp/frontend.zip
echo -e "\e[31m >>>>>>>>>>>>>>>>>copying the congiguration file<<<<<<<<<<<<<<<<<<<<\e[0m"
cp /home/centos/roboshop-shell/roboshop.conf /etc/nginx/default.d/roboshop.conf
echo -e "\e[31m >>>>>>>>>>>>>>>>>restarting the nginx<<<<<<<<<<<<<<<<<<<<\e[0m"
systemctl restart nginx
echo -e "\e[31m >>>>>>>>>>>>>>>>>checking the status of nginx service <<<<<<<<<<<<<<<<<<<<\e[0m"
systemctl status nginx
