# ----------------------------
# lab038-jenkins-cluster
Author: Frank Effrim-Botchey
# ----------------------------


# --------------------------
## Part 1 Main Objectives
# --------------------------
[00] Build/refactor code that is re-usable and streamlined

[01] Use Terrafrom/Private modules to enable the following AWS resources to be built on a terraform run: [Done]

    - Multiple EC2 instances 

    - Network Interface 

    - Elastic IP 

    - AMI - Ubuntu/Amazon Linux 2 or pre configured snashot

    - VPC 

    - Internet Gateway

    - Route Table

    - Route Table Association

    - Subnet

    - Security Group (allow http, https & ssh)

    - Elastic Loadbalancer

[02] Enable the same EIP to persist even after a Terraform destroy & re-apply 

[03] Use Route53 to auto create dns record in specific Hosted Zone for Jenkins server during TF run [Done]

[04] Use dns name to connect to Jenkins Server [Done]

[05] Open Server SG to allow access to Jenkins server (port 8080) [Done]

[06] Execute a Terraform run to build the above resources.  [Done]

        - User should be able to connect to a single jenkins server using its dns name on port 8080.  

        - User should see jenkins registration page.


# --------------------------
## Part 2 Feature Objectives
# --------------------------

[01] AUTO BUILD NEW SERVER SOFTWARE [Done]

        - Install Ubuntu, Java & jenkins onto new EC2 & manually complete the jenkins registration process.

        or

        - Use Ansible to auto build new jenkins server and auto complete registratoion process

[02] USE SNAPSHOT TO BUILD SERVER SOFTWARE [Done]

        - Terraform will look for an existing snapshot in the region and use that to build ec2 instances.
        
        - Snapshot will contain java, jenkins and any user data such as jenkins jobs etc.

[03] Provide an option at runtime to auto build a new jenkins server or use a snapshot of a pre-built jenkins server. [Done]

[04] Provide an option to create a snapshot of jenkins server when infrastructure is destroyed.


# --------------------------
## Part 3 Feature Objectives
# --------------------------

[01] Enable multiple servers to be created on same network infrastructure [Done]

[02] Enable loadbancing using aws elb.

[03] Configure jenkins in a cluster and save build as new snapshot


# --------------------------
## Part 4 Feature Objectives
# --------------------------

[01] Introduce auto scaling resources to be optionally built


# --------------------------
## Part 5 Feature Objectives
# --------------------------

[01] Setup monitoring Cloudwatch alarms

[02] Send email/text alerts based on Cloudwatch alarms

# --------------------------
## Part 6 Feature Objectives
# --------------------------

[01] Use Terraform Cloud as the backend instead of a local backend. 

[02] Trigger TF runs once code is upload to Github repo



# --------------------------
## Part 7 Feature Objectives
# --------------------------

[01] Build this project in Docker containers instead of individual aws resources



# --------------------------
## Pre Requisits
# --------------------------

The region where the server is to built needs to have the following existing AWS resources:

        - An elastic-ip named "my-eip-<region>"

        - A key-pair name "my-kp-eu-<region>"

        - A snapshot of a pre-configured server/backup named "my-snapshot-<region>"  
