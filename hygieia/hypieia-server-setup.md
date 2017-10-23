
See http://www.capitalone.io/Hygieia/setup.html#hygieia-setup-instructions

https://console.cloud.google.com/compute?project=attiopinfosys

gcloud beta compute --project "attiopinfosys" instances create "hygieia-1" --zone "us-central1-f" --machine-type "n1-standard-1" --subnet "default" --maintenance-policy "MIGRATE" --service-account "776279044010-compute@developer.gserviceaccount.com" --scopes "https://www.googleapis.com/auth/devstorage.read_only","https://www.googleapis.com/auth/logging.write","https://www.googleapis.com/auth/monitoring.write","https://www.googleapis.com/auth/servicecontrol","https://www.googleapis.com/auth/service.management.readonly","https://www.googleapis.com/auth/trace.append" --min-cpu-platform "Automatic" --tags "http-server","https-server" --image "ubuntu-1604-xenial-v20171011" --image-project "ubuntu-os-cloud" --boot-disk-size "20" --boot-disk-type "pd-standard" --boot-disk-device-name "hygieia-1"

within server: ------------------------------------------------------------------------
<pre>
sudo apt-get -y install default-jdk \
   git \
   maven 

java -version  # "1.8.0_131"
git -v

git clone https://github.com/capitalone/Hygieia.git --depth=1 && cd Hygieia
mvn clean install package
</pre>

[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
[INFO] Total time: 10:30 min
[INFO] Finished at: 2017-10-23T17:35:11+00:00
[INFO] Final Memory: 196M/471M
[INFO] ------------------------------------------------------------------------


Client ---------------------
<pre>
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew install node
npm install -g bower
npm install -g gulp

npm install
bower install
</pre>
