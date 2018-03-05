#!/bin/bash
# From https://github.com/viswanath42/Docker_Lab/blob/master/tomcat_image/run.sh

if [ ! -f /.tomcat_admin_created ]; then
    /create_tomcat_admin_user.sh
fi

sed -i "s/bindOnInit=\".*\"/bindOnInit=\"${TOMCAT_BIND_ON_INIT}\"/" /tomcat/conf/server.xml

export CATALINA_OPTS="$CATALINA_OPTS ${JAVA_OPTS}"

exec ${CATALINA_HOME}/bin/catalina.sh run
