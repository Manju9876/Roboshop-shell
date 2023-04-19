yum install nginx -y
systemctl enable nginx
systemctl start nginx
rm -rf /usr/share/nginx/html/*
cd /usr/share/nginx/html
unzip /tmp/frontend.zip
cp roboshop.conf /etc/nginx/default.d/roboshop.conf
systemctl restart nginx