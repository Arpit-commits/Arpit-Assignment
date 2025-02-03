![Picture1](https://github.com/user-attachments/assets/f3981de3-d3e6-446b-a2cc-0d046e0d8fed)

# 🏗️ Two-Tier Web Application Deployment with Docker & AWS ECR

## Introduction

This project demonstrates the deployment of a **two-tier web application** using **Docker, AWS Elastic Container Registry (ECR), and Terraform**. The application consists of:

The goal is to **containerize the application**, store images in **AWS ECR**, and deploy them on an **EC2 instance** using Terraform. This setup ensures **scalability, automation, and cloud-based deployment**.

By the end of this project, you'll have a **fully functional web application** running on AWS infrastructure. 🚀

### Pointers
```
This assignment is about deploying a two-tier web application using Docker, AWS ECR, and Terraform.
```
```
Set up the environment: Install Docker, AWS CLI, and Terraform.
```
```
Build Docker Images: Create and test MySQL and WebApp Docker images locally.
```
```
Push Images to AWS ECR: Store the Docker images in AWS Elastic Container Registry (ECR).
```
```
Launch EC2 Instance: Use Terraform to create an EC2 instance for hosting the application.
```
```
Deploy Containers on EC2: Run MySQL and WebApp containers on the instance using AWS ECR images.
```
```
Test the Deployment: Verify that the web application connects to the database and runs correctly.
```
```
Scale the WebApp: Deploy multiple web app containers with different colors.
```
```
This project demonstrates containerization, cloud deployment, and automation using AWS services.
```

# Install the required MySQL package
```
sudo apt-get update -y
sudo apt-get install mysql-client -y
```

# Running application locally
```
pip3 install -r requirements.txt
python3 app.py
```

# Building and running 2 tier web application locally
### Building mysql docker image 
```
docker build -t my_db -f Dockerfile_mysql . 
```

### Building application docker image 
```
docker build -t my_app -f Dockerfile . 
```

### Running mysql
```
docker run -d -e MYSQL_ROOT_PASSWORD=pw  my_db
```


### Get the IP of the database and export it as DBHOST variable
```
docker inspect <container_id>
```


### Example when running DB runs as a docker container and app is running locally
```
export DBHOST=127.0.0.1
export DBPORT=3307
```
### Example when running DB runs as a docker container and app is running locally
```
export DBHOST=172.17.0.2
export DBPORT=3306
```
```
export DBUSER=root
export DATABASE=employees
export DBPWD=pw
export APP_COLOR=blue
```
### Run the application, make sure it is visible in the browser
```
docker run -p 8080:8080 -e APP_COLOR=$APP_COLOR -e DBHOST=$DBHOST -e DBPORT=$DBPORT -e DBUSER=$DBUSER -e DBPWD=$DBPWD  my_app
```


#### Commands History
```
tf fmt 
tf init
tf plan
tf apply
```
### connect to instance - 
```
sudo apt update -y
sudo apt install -y docker.io
sudo systemctl start docker
sudo systemctl enable docker
docker --version
sudo systemctl status docker
sudo usermod -aG docker $USER   (adding user mod to docker image)

exit and login again 
---------------------
```
### custom network of type bridge
docker network create -d bridge --subnet 10.0.0.0/24 --gateway 10.0.0.1 my-network 
```
sudo apt install awscli
sudo apt install awscli
aws ecr get-login-password --region us-east-1 | docker login -u AWS 135893829551.dkr.ecr.us-east-1.amazonaws.com/mysql-repo:mysql-latest --password-stdin
```

ecr_db=135893829551.dkr.ecr.us-east-1.amazonaws.com/mysql-repo:mysql-latest
aws ecr get-login-password --region us-east-1 | docker login -u AWS 135893829551.dkr.ecr.us-east-1.amazonaws.com/mysql-repo:mysql-latest --password-stdin

docker run -d -e MYSQL_ROOT_PASSWORD=pw --network my-network --name mysql-db $ecr_db

docker run -d -e MYSQL_ROOT_PASSWORD=pw --network my-network --name mysql-db 135893829551.dkr.ecr.us-east-1.amazonaws.com/mysql-repo:mysql-latest
----------------
```
```
### for pulling webapp_repo image
```
b6f57f8d30c1541b1c7f282a47f5e577b85f092e686ccc9ff66184e492487f9f
ecr_app=135893829551.dkr.ecr.us-east-1.amazonaws.com/webapp-repo:app-latest
aws ecr get-login-password --region us-east-1 | docker login -u AWS 135893829551.dkr.ecr.us-east-1.amazonaws.com/webapp-repo:app-latest --password-stdin
aws ecr get-login-password --region us-east-1 | docker login -u AWS $ecr_app --password-stdin
ecr_db=135893829551.dkr.ecr.us-east-1.amazonaws.com/mysql-repo:mysql-latest
```
docker run -d -e MYSQL_ROOT_PASSWORD=pw --network my-network --
docker run -d -e MYSQL_ROOT_PASSWORD=pw --network my-network --name mysql-db ecr_db=844188451376.dkr.ecr.us-east-1.amazonaws.com/mysql_repo:mysql-latest

it will show us the container id 
```
do docker inspect 
docker inspect 48cbdecd6b31211d5813e85871608a0cf994e77aab3d63127506d2ad53815b4a
```
---------------
### test MySQL db connection and showing created database
```
docker exec -it mysql-db /bin/bash
mysql -uroot -ppw -e "SHOW DATABASES;"

exit
------------------
export DBHOST=10.0.0.2
export DBPORT=3306
export DBUSER=root
export DATABASE=employees
export DBPWD=pw
----------------
```
### for pulling webapp_repo image
```
ecr_app=135893829551.dkr.ecr.us-east-1.amazonaws.com/webapp-repo:app-latest
aws ecr get-login-password --region us-east-1 | docker login -u AWS 135893829551.dkr.ecr.us-east-1.amazonaws.com/webapp-repo:app-latest --password-stdin
```
-------------------------
### running containers in detach mode for 
```
docker run -d -p 8081:8080 -e DBHOST=$DBHOST -e DBPORT=$DBPORT -e DBUSER=$DBUSER -e DATABASE=$DATABASE -e DBPWD=$DBPWD -e APP_COLOR=blue --network my-network --name webappblue $ecr_app
docker run -d -p 8082:8080 -e DBHOST=$DBHOST -e DBPORT=$DBPORT -e DBUSER=$DBUSER -e DATABASE=$DATABASE -e DBPWD=$DBPWD -e APP_COLOR=pink --network my-network --name webapppink $ecr_app
docker run -d -p 8083:8080 -e DBHOST=$DBHOST -e DBPORT=$DBPORT -e DBUSER=$DBUSER -e DATABASE=$DATABASE -e DBPWD=$DBPWD -e APP_COLOR=lime --network my-network --name webapplime $ecr_app
----------------
Containers can ping each other using their host names. For example, the following should work from inside the blue container: ping pink ping lime
-----------------------
docker exec -it webappblue /bin/bash
docker exec -it webapppink /bin/bash
docker exec -it webapplime /bin/bash
 
### install ping
apt-get update && apt-get install iputils-ping -y	
-------------
ping webapplime
ping webapppink
ping webappblue
```

### Error History and Solutions 
```
1 – Security Group Issue 
Problem: EC2 instance couldn’t connect because security group rules were incorrect.
Solution: Updated Terraform to allow necessary inbound/outbound traffic for SSH, HTTP, and the application ports.
```
```
2 - Git Large File Issue:
Problem: Tried to push large Terraform files exceeding GitHub's 100MB limit.
Solution: Removed unnecessary .terraform directories and used .gitignore to avoid tracking them.
```
```
3 - Branch Checkout Issue:
Problem: Couldn't switch branches due to untracked files.
Solution: Moved or removed conflicting files before switching branches. As I was using 3 Branches in Total Development , Staging and Main 
```
```
4 – Key Issue Authentication 
Problem : First I created a private key to login to the newely created and then pushed the key with the code in the github then once again going through the documentation I realized that’s not necessary as I can connect to the instance directly from the AWS connect 
Solution : I removed the key when I created the staging branch where the code is mostly sorted and removed more un-necessary files 
```
```
5 - Missing ECR Repository:
Problem: Docker push failed because mysql-repo and webapp-repo didn’t exist.
Solution: Added Terraform code to create mysql-repo and webapp-repo in AWS ECR, This happened because when I ran the terraform code locally the previous repo were already there as they did not got destroyed , but when I reset and started fresh again I needed to create the repo in ECR so later added them in the terraform code
voclabs:~/environment/Arpit-Assignment (main) $ docker push 135893829551.dkr.ecr.us-east-1.amazonaws.com/mysql:latest The push refers to repository [135893829551.dkr.ecr.us-east-1.amazonaws.com/mysql] 21e57c4a201c: Preparing a3d707e222b9: Preparing 9dad147013d2: Preparing f130fbfe77ff: Waiting b50bc0309705: Waiting 69b327c9e57e: Waiting 4683b2db23ba: Waiting 88ae57e8be69: Waiting ca760287abdb: Waiting edb9a1d4fec8: Waiting 477d917f8fdf: Waiting 7600fdef234b: Waiting name unknown: The repository with name 'mysql' does not exist in the registry with id '135893829551' voclabs:~/environment/Arpit-Assignment (main) $
```
```
6- Ping Command not found
Problem : Had issue when trying to ping 1 web app to the another one 
Solution:as ping utility was missing installed it and then we were able to ping the other webApps
```
```
7 – Ubuntu Package Manager Issue:
Problem: Ubuntu doesn’t support yum, needed for installing dependencies.
Solution: Used apt instead of yum to install required packages.
```
```
8 - Multiple Subnets
Problem: AWS environment, and Terraform cannot decide which one to use without more specific criteria
Solution: added aws_subnet block in the terraform code
```
```
9 – Duplicate Definitions
Problem : I Put output in both places , Output.tf and Main.tf in terraform code 
Solution : Removed the duplicate output definitions and changed to only main.tf
```
```
10 – AWS Image
Problem – AWS image not found 
RunInstances, https response error StatusCode: 400, RequestID: 903a45c5-0fef-4356-b64e-231a860c2922, api error InvalidAMIID.NotFound: The image id '[ami-0c55b159cbfafe1f0]' does not exist
Solution : Used Dynamic AMI id
```
```
11 - Argument is deprecated
Problem :
│ Warning: Argument is deprecated │ │ with aws_eip.nat_ip, │ on main.tf line 43, in resource "aws_eip" "nat_ip": │ 43: vpc = true │ │ use domain attribute instead │ │ 
Solution : solution is to use associate_with_private_ip , used eip block in the code 
resource "aws_eip" "nat_ip" { domain = "vpc" # Use "domain" instead of "vpc = true" }
```
```
```
### Summary
```
This project deploys a two-tier web application using Docker, AWS ECR, and Terraform.
The database and application run in separate containers on a custom network.
Environment variables manage database credentials and app color themes.
The web application can be scaled by running multiple containers with different colors.
```
