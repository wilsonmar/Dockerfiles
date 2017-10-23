1. Sign into your Gmail account for billing.
2. Within Google Compute Engine, create a server instance:

   https://console.cloud.google.com/compute/instances?project=attiopinfosys
   
3. In the VM, deploy NodeJS, NPM, Angular CLI, and NGINX server.
 
4. From a VNC client visit the instance, for example: 35.197.105.74.
 
0. For deploying your version of the Angular APP, refresh the folder with your app content at:

   /var/www/html
 
0. To restart the NGINX server on the VM use 

   sudo systemctl restart nginx
 

