#!/bin/bash

sudo yum install -y httpd

sudo systemctl enable --now httpd

echo "<h1>Welcome to Apache Server $(hostname -f)</h1>" | sudo tee /var/www/html/index.html