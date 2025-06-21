#!/bin/bash

# Script to set up Nginx as a load balancer for multiple Node.js applications
# and serve a static frontend application.
# When run, it will configure Nginx to balance requests
# between the specified backend Node.js applications and serve a static frontend. It returns a 404 error for any non-existent files in the frontend directory.
# This script assumes that Nginx is already installed on the system.
# Usage: Run this script as root or with sudo privileges.
# Author: Ethagbe Michael
# Date: 2024-11-10



upstream backend_apis { 
least_conn; 
server serverIP:3001; 
server serverIP:3002; 
} 
server { 
listen 80; 
server_name <your_domain_or_ip>; 
root /var/www/frontend; 
index index.html; 
# Serve frontend (HTML, CSS, JS, etc.) 
location / { 
try_files $uri $uri/ =404; 
} 
# Proxy API requests to backend Node.js apps 
location /api/ { 
proxy_pass http://backend_apis; 
proxy_http_version 1.1; 
proxy_set_header Host $host; 
proxy_set_header X-Real-IP $remote_addr; 
proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for; 
} 
}