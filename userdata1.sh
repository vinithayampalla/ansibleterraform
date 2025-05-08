#! /bin/bash
# shellcheck disable=SC2164
cd /home/ubuntu
yes | sudo apt update
yes | sudo apt install python3 python3-pip zip unzip
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
git clone https://github.com/vinithayampalla/code.git
sleep 20
# shellcheck disable=SC2164
cd code
#pip3 install -r requirements.txt -t . --break-system-packages
pip3 install flask pymysql serverless-wsgi  -t . 

echo 'Waiting for 30 seconds before running the app.py'
zip -r deployment.zip .


#setsid python3 -u app.py &

sleep 30