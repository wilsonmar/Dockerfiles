#! /bin/bash
# sonar1.sh From https://github.com/wilsonmar/Dockerfiles/
# Here is an example (change the sources with the path to your source code; change login token to your SonarQube instance).
chmod 555 sonar-scanner
./sonar-scanner \
  -Dsonar.projectKey=Angular-35.202.3.232 \
  -Dsonar.sources=/Users/wilsonmar/gits/ng \
  -Dsonar.host.url=http://35.202.3.232 \
  -Dsonar.login=b0b030cd2d2cbcc664f7c708d3f136340fc4c064
