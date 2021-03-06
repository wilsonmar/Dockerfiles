https://www.digitalocean.com/community/tutorials/how-to-install-java-on-ubuntu-with-apt-get
https://poweruphosting.com/blog/install-java-ubuntu/

The Oracle JDK is no longer provided by Oracle as a default installation for Ubuntu.

## Installing default JRE/JDK

The default version differs by OS version:

   * Ubuntu 12.10+ versions have Open JDK 7. 
   * Ubuntu 12.04 and earlier version have Open JDK 6  

First, update the package index:

   sudo apt-get update

Check if Java is not already installed:

   java -version

If it returns "The program java can be found in the following packages", Java hasn't been installed yet.

For JRE, execute the following command:

   sudo apt-get install default-jre

For JDK to compile Java applications:

   sudo apt-get install default-jdk

That is everything that is needed to install Java.


## Installing OpenJDK 7 (optional)

For the JRE to OpenJDK 7:

   sudo apt-get install openjdk-7-jre 

For JDK 7:

   sudo apt-get install openjdk-7-jdk

## Installing Oracle JDK (optional)

You can still install it using apt-get. To install any version, first execute the following commands:

sudo apt-get install python-software-properties
sudo add-apt-repository ppa:webupd8team/java
sudo apt-get update

Then, depending on the version you want to install, execute one of the following commands:
Oracle JDK 6

This is an old version but still in use.

   sudo apt-get install oracle-java6-installer

Oracle JDK 7

This is the latest stable version.

   sudo apt-get install oracle-java7-installer

Oracle JDK 8

   sudo apt-get install oracle-java8-installer

Managing Java (optional)

When there are multiple Java installations on your Droplet, the Java version to use as default can be chosen. To do this, execute the following command:

   sudo update-alternatives --config java

It will usually return something like this if you have 2 installations (if you have more, it will of course return more):

There are 2 choices for the alternative java (providing /usr/bin/java).

Selection    Path                                            Priority   Status
------------------------------------------------------------
* 0            /usr/lib/jvm/java-7-oracle/jre/bin/java          1062      auto mode
  1            /usr/lib/jvm/java-6-openjdk-amd64/jre/bin/java   1061      manual mode
  2            /usr/lib/jvm/java-7-oracle/jre/bin/java          1062      manual mode

Press enter to keep the current choice[*], or type selection number:

You can now choose the number to use as default. This can also be done for the Java compiler (javac):

   sudo update-alternatives --config javac

It is the same selection screen as the previous command and should be used in the same way. This command can be executed for all other commands which have different installations. In Java, this includes but is not limited to: keytool, javadoc and jarsigner.
Setting the "JAVA_HOME" environment variable

To set the JAVA_HOME environment variable, which is needed for some programs, first find out the path of your Java installation:

   sudo update-alternatives --config java

It returns something like:

There are 2 choices for the alternative java (providing /usr/bin/java).

Selection    Path                                            Priority   Status
------------------------------------------------------------
* 0            /usr/lib/jvm/java-7-oracle/jre/bin/java          1062      auto mode
  1            /usr/lib/jvm/java-6-openjdk-amd64/jre/bin/java   1061      manual mode
  2            /usr/lib/jvm/java-7-oracle/jre/bin/java          1062      manual mode

Press enter to keep the current choice[*], or type selection number:

The path of the installation is for each:

    /usr/lib/jvm/java-7-oracle

    /usr/lib/jvm/java-6-openjdk-amd64

    /usr/lib/jvm/java-7-oracle

Copy the path from your preferred installation and then edit the file /etc/environment:

   sudo nano /etc/environment

In this file, add the following line (replacing YOUR_PATH by the just copied path):

   JAVA_HOME="YOUR_PATH"

That should be enough to set the environment variable. Now reload this file:

   source /etc/environment

Test it by executing:

   echo $JAVA_HOME

If it returns the just set path, the environment variable has been set successfully. If it doesn't, please make sure you followed all steps correctly.
