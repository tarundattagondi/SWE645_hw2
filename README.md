SWE645 - Homework Assignment 1
NAME: GONDI TARUN DATTA
GID: G01547449

index.html → Introduces myself and highlights how SWE645 will help me learn DevOps and Cloud Computing skills.
survey.html → A survey form (styled with W3.CSS).
error.html → An error page.
mypic.png → Personal image used in the website.


--> EC2 Setup & Deployment Steps

--> 1. Launch EC2 Instance
Region: N. Virginia (us-east-1)
AMI: Amazon Linux 2
Instance Type: t2.micro
Key Pair: 645ha1.pem
Security Group:
  Allow SSH  from My IP
  Allow HTTP from Anywhere (0.0.0.0/0)

--> 2. Connect to Instance (Mac)

ssh -i ~/Desktop/SWE645_HA1/645ha1.pem ec2-34-226-138-42.compute-1.amazonaws.com


--> 3. Install Apache in ec2 server

sudo yum update -y
sudo yum install -y httpd
sudo systemctl start httpd
sudo systemctl enable httpd


--> 4. Upload Files from Local to EC2

cd ~/Desktop/SWE645_HA1
scp -i 645ha1.pem index.html survey.html error.html mypic.png ec2-34-226-138-42.compute-1.amazonaws.com:/home/ec2-user/

--> 5. Deploy Files to Apache Root

ssh -i ~/Desktop/SWE645_HA1/645ha1.pem ec2-34-226-138-42.compute-1.amazonaws.com

--> Inside SSH session:
sudo rm -f /var/www/html/index.html
sudo mv /home/ec2-user/index.html  /var/www/html/
sudo mv /home/ec2-user/survey.html /var/www/html/
sudo mv /home/ec2-user/error.html  /var/www/html/
sudo mv /home/ec2-user/mypic.png   /var/www/html/


--> 6. Test in Browser
Homepage: http://34.226.138.42/index.html
Survey:   http://34.226.138.42/survey.html
Error:    http://34.226.138.42/error.html


--> EC2 Public URL

http://34.226.138.42/index.html


--> S3 Bucket URL (if used for static hosting)

Create bucket:-
name:swe645-ha1-tarundatta
unclick block all public access
and create bucket

Upload html files
after saving the upload files go to Properties:
Enable Static website hosting
then go to Permissions
edit bucket policy as:
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::swe645-ha1-tarundatta/*"
        }
    ]
}

S3 Public link : http://swe645-ha1-tarundatta.s3-website-us-east-1.amazonaws.com



Name :- Gondi Tarun Datta
GID: G01547449