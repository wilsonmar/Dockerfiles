# From https://github.com/viswanath42/Docker_Lab/blob/master/java_image/Dockerfile

FROM centos:latest

RUN yum install -y wget; wget --no-cookies --no-check-certificate --header "Cookie: oraclelicense=accept-securebackup-cookie" \
		http://download.oracle.com/otn-pub/java/jdk/8u131-b11/d54c1d3a095b4ff2b6607d096fa80163/jre-8u131-linux-x64.rpm -O /tmp/jre-8u131-linux-x64.rpm; \
              	yum install -y /tmp/jre-8u131-linux-x64.rpm;yum remove -y wget;

#ENV JAVA_HOME /usr/bin/java

RUN echo $JAVA_HOME;/usr/bin/java -version
