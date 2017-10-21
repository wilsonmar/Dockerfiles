## Create within Google Compute Engine

1. Use your Gmail account to obtain $300 of credit the first year at https://console.developers.google.com/freetrial
0. Be at the Google Cloud Platform Console: https://console.cloud.google.com/compute/instances
0. Click Create (a new instance).
0. Change the instance name from `instance-1` to `montebank-1` (numbered in case you'll have more than one).
0. Set the zone to `us-central-1f` or where your other instances are, or your closest geographical location.
0. Set machine type to `f1-micro`.
0. Click Boot Disk to select `Ubuntu 16.04 LTS` instead of default `Debian GNU/Linux 9 (stretch)`.

   PROTIP: GCE does not provide the lighter  http://alpinelinux.org/

0. Type a larger Size (GB) than the default 10 GB.

   <pre>
   WARNING: You have selected a disk size of under [200GB]. This may result in poor I/O performance. For more information, see: https://developers.google.com/compute/docs/disks#performance.
   </pre>
   
0. Allow HTTP & HTPPS traffic.
0. Click "Management, disks, networking, SSH keys".
0. In the <strong>Startup script</strong> field, if you've already tested the steps, paste:

   <pre>
   lsb_release -a
   sudo apt-get update
   sudo apt-get install -y nodejs
   # To avoid using sudo for npm in /usr/local:
   #export MEUSER=$USER
   #sudo npm set prefix '/home/$MEUSER/.npm' –global
   #sudo npm get prefix
   #echo "export PATH=$PATH: $HOME/.npm/bin" >> $HOME/.profile
   sudo npm install -g mountebank -y
   mb
   </pre>

   Alternately, if you have a image in DockerHub:
   
   <pre>
   # Install Docker: 
   curl -fsSL https://get.docker.com/ | sh
   sudo docker pull mountebank
   sudo docker run -d --name mountebank -p 9000:9000 -p 9092:9092 mountebank
   </pre>

0. Click "command line" link for a pop-up of the equivalent command.
0. Copy and paste it in a text editor to save the command for troubleshooting later.

0. Click <strong>Create</strong> the instance. This <a target="_blank" href=
"https://cloudplatform.googleblog.com/2017/07/three-steps-to-Compute-Engine-startup-time-bliss-Google-Cloud-Performance-Atlas.html">cold-boot takes time</a>:

   ![gce-startup-time-640x326](https://user-images.githubusercontent.com/300046/31769426-262e939a-b499-11e7-8c7d-7e4bf0057107.png)

   Boot time to execute startup scripts is the variation <a target="_blank" href="https://goo.gl/S0AS51">cold-boot performance</a>.

0. Click SSH to SSH into instance via the web console, using your Google credentials.
0. In the new window, `pwd` to see your account home folder.

0. To see instance console history:

   `cat /var/log/startupscript.log`


gcloud beta compute --project "cicd-182518" instances create "hygieia-1" --zone "us-central1-f" --machine-type "n1-standard-1" --subnet "default" --metadata "startup-script=lsb_release -a" --maintenance-policy "MIGRATE" --service-account "608556368368-compute@developer.gserviceaccount.com" --scopes "https://www.googleapis.com/auth/devstorage.read_only","https://www.googleapis.com/auth/logging.write","https://www.googleapis.com/auth/monitoring.write","https://www.googleapis.com/auth/servicecontrol","https://www.googleapis.com/auth/service.management.readonly","https://www.googleapis.com/auth/trace.append" --min-cpu-platform "Automatic" --tags "http-server","https-server" --image "ubuntu-1604-xenial-v20171011" --image-project "ubuntu-os-cloud" --boot-disk-size "10" --boot-disk-type "pd-standard" --boot-disk-device-name "hygieia-1"
