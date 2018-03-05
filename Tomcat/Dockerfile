# From https://github.com/viswanath42/Docker_Lab/blob/master/tomcat_image/Dockerfile

FROM viswa123/jre_golden_image:latest

ENV TOMCAT_MAJOR_VERSION 8
ENV TOMCAT_MINOR_VERSION 8.0.44
ENV CATALINA_HOME /tomcat
ENV JAVA_OPTS ""
ENV TOMCAT_BIND_ON_INIT true

RUN yum -y update;yum install -y ca-certificates;\
	yum install -y --no-install-recommends libtcnative-1;\
	yum install -y wget; \
	wget -q https://archive.apache.org/dist/tomcat/tomcat-8/v8.0.44/bin/apache-tomcat-8.0.44.tar.gz; \
	wget -qo- https://archive.apache.org/dist/tomcat/tomcat-8/v8.0.44/bin/apache-tomcat-8.0.44.tar.gz.md5 | md5sum; \
	tar zxf apache-tomcat-*.tar.gz;\
	rm apache-tomcat-*.tar.gz;\
	mkdir /tomcat;\
    	mv apache-tomcat-8.0.44/* /tomcat;\
    	rm -fr /tomcat/webapps/examples;\
    	rm -fr /tomcat/webapps/docs;\
	ls -ltr /tomcat;\
    	sed -i "s/Connector port=\"8080\"/Connector port=\"8080\" bindOnInit=\"${TOMCAT_BIND_ON_INIT}\"/" /tomcat/conf/server.xml;

ADD create_tomcat_admin_user.sh /create_tomcat_admin_user.sh
COPY CIS-0.0.1-SNAPSHOT.war $CATALINA_HOME/webapps/ 
ADD run.sh /run.sh
RUN chmod +x /*.sh

EXPOSE 8080
CMD ["/run.sh"]
