0. Instantiate server on Google.

0. Access data for Kong to change the default credentials on first login.

   These are the Cassandra credentials for the administrator user.

   Username: cassandra
   Password: Created on first boot. Follow these instructions on how to retrieve the password. 

0. System Access Data

   To access the machine via SSH, follow instructions in the documentation.
   https://docs.bitnami.com/google/faq/#how-to-connect-to-the-server-through-ssh

   Username: Set during the virtual machine launch

0. A control script lets you easily stop, start and restart Kong and Cassandra. 
   Obtain a list of available services and operations by running this script (without any arguments):

   <pre><strong>
   sudo /opt/bitnami/ctlscript.sh    
   </strong></pre>
      

Kong CLI
https://getkong.org/docs/latest/cli/
The Kong CLI provides you with an interface to manage your Kong nodes. In this instance, Kong will by default attempt to load the configuration file at /opt/bitnami/apps/kong/conf/kong.conf. Also you should execute the kong command as the kong user.


      $ cd /opt/bitnami/apps/kong
      $ sudo su kong
      $ bin/kong --help
      

Using Kong

Quickly learn how to use Kong with the Getting started guide:
https://getkong.org/docs/latest/getting-started/adding-your-api/

Next Steps

    Kong can be configured and customized to your needs - check out the Kong Configuration Reference
    https://getkong.org/docs/latest/configuration/
    
    Clustering is an important and powerful Kong feature - you can add nodes to your cluster
    https://docs.bitnami.com/google/apps/kong/#how-to-create-a-kong-cluster
    
    Going to production! If you are already planning to go into production you should make some changes to your setup
    https://docs.bitnami.com/google/apps/kong/#how-to-set-kong-for-production-environments

Do you need help?

A Quick Start Guide and FAQs for Kong are available in the Bitnami Documentation for Google Cloud Platform.

   If you can't find an answer to your question there, post to our active Community forums.


0. Edit file in /opt/bitnami/apps/kong/conf/kong_nginx.tmpl
   to disable the welcome screen by removing this:

   <pre>
   include /opt/kong/apps/bitnami/banner/conf/infopage.conf;
   </pre>

0. restart Kong:

   <pre><strong>sudo /opt/bitnami/ctlscript.sh restart kong 
   </strong></pre>

0. For more, read https://getkong.org

