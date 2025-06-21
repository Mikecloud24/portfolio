# This is Nginx-loadbalancer web server implementation

-The script set up Nginx as a load balancer for multiple Node.js applications and serve a static frontend application.

- When run, it will configure Nginx to balance requests between the specified backend Node.js applications and serve a static frontend.


# Note:

- Make sure the neccessary owner permissions are given to the website folder dir at web root in nginx (like this: sudo chown -R www-data:www-data /var/www/<foldername>)
- Make sure the neccessary dependencies are installed at the backend servers & start the Backends

- Then Create Symbolic Link to Sites Enabled & Restart Nginx 

     - Commands:
     - sudo ln -s /etc/nginx/sites-available/<your config file name> /etc/nginx/sites-enabled/    # for symbolic link
     - sudo nginx -t                                                                              # to test your config file
     - sudo systemctl reload nginx                                                                # to reload nginx