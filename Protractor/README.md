Protractor is used to test Angular apps. See 

   * https://angular.io/tutorial (A Tour of Heros)
   * https://github.com/angular/angular-cli/wiki = CLI Documentation
   * https://blog.angular.io/ = Angular Blog
   
1. Sign into your Gmail account for billing.
2. Within Google Compute Engine, create a server instance:

   https://console.cloud.google.com/compute/instances?project=attiopinfosys
 
   Disk space?
 
3. In the VM, deploy NodeJS, NPM, Angular CLI, and NGINX server, git.

0. Clone
 
   https://github.com/ramkict/aprotractor

   NOTE: An alternative (not referenenced here):
   https://github.com/angular/protractor
   
0. Run Maven ?

0. In a browser, visit the IP address for the Angular app's UI: http://35.197.119.148/ 

0. Use a VNC client to visit the instance at VNC port 5901. For example:

   VNC://35.197.119.148:5901

0. Specify the ‘password’ to complete the connection.
 
   A VNC session should open within "Screen Sharing" app on MacOS.
 
0. For deploying your version of the Angular APP, refresh the folder with your app content at:

   /var/www/html
   
   This contains index.html, facicon.ico, and various .js files and the .js.map files they reference.
 
0. To restart the NGINX server on the VM use 

   sudo systemctl restart nginx
 
0. Open a terminal session and navigate to the folder:

   cd /home/njganeshv/
   cd aprotractor/aprotractor

0. Run in the GCP VM:

   ng test

0. Also run in the GCP VM:

   ng e2e

   This spawns off chrome session to perform the tests.

   See results of the test will get displayed on the terminal window.

0. To run the application. Use the command ng serve. This will instantiate an HTTP server on port 4200.

0. Invoke the Chrome browser from VNC session to connect to http://localhost:4200/ to browse through the application.

