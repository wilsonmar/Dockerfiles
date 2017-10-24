Protractor is used to test Angular apps. 
   
1. Sign into your Gmail account for billing.
2. Within Google Compute Engine, create a server instance:

   <a target="_blank" href="
   https://console.cloud.google.com/compute/instances?project=attiopinfosys">
   https://console.cloud.google.com/compute/instances?project=attiopinfosys</a>
 
   Disk space?
 
3. In the VM, deploy NodeJS, NPM, Angular CLI, and NGINX server, git.

0. Clone from source repository:
 
   <a target="_blank" href="
   https://github.com/ramkict/aprotractor">
   https://github.com/ramkict/aprotractor</a>

   The app UI is a big Angular logo with 3 links:

   * https://angular.io/tutorial (A Tour of Heros)
   * https://github.com/angular/angular-cli/wiki = CLI Documentation
   * https://blog.angular.io/ = Angular Blog

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

   <pre>
   sudo systemctl restart nginx
   </pre>

0. Open a terminal session and navigate to the folder:

   <pre>
   cd /home/njganeshv/
   cd aprotractor/aprotractor
   </pre>
   
0. Run in the GCP VM:

   <pre>
   ng test
   </pre>

0. Also run in the GCP VM:

   <pre>
   ng e2e
   </pre>

   This spawns off chrome session to perform the tests.

0. Results of the test are displayed on the terminal window at
   
   http://localhost:4200/list

0. To run the application (instantiate an HTTP server on port 4200):

   <pre>
   ng serve
   </pre>

An alternative app (not referenenced here): https://github.com/angular/protractor

