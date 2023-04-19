curl -sL https://rpm.nodesource.com/setup_lts.x | bash
yum install nodejs -y
systemctl start catalogue
systemctl enable catalogue
useradd roboshop
mkdir /app
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip
cd /app
unzip /tmp/catalogue.zip
npm install
cp /home/centos/roboshop-shell/catalogue.service  /etc/systemd/system/catalogue.service
systemctl daemon-reload
systemctl restart catalogue
cp /home/centos/roboshop-shell/mongo.repo /etc/yum.repos.d/mongo.repo
yum install mongodb-org-shell -y
mongo --host mongodb-dev.manju-devops.online </app/schema/catalogue.js
