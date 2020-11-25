 #!/bin/bash
    sudo yum update -y
    sudo yum install httpd -y
    sudo systemctl enable httpd
    sudo systemctl start httpd
    echo "<html><body><div>Hello, world!.. from $(hostname -f) </div></body></html>" > /var/www/html/index.html