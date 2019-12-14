FROM tomcat:7 as builder
MAINTAINER Jan Garaj info@monitoringartist.com

COPY TIB_js-jrs-cp_7.2.0_bin.zip /tmp/jasperserver.zip
RUN unzip /tmp/jasperserver.zip -d /tmp \
  && mv /tmp/jasperreports-server-cp-7.2.0-bin /jasperserver

FROM tomcat:7
COPY --from=builder /jasperserver /jasperserver

ENV \
  JS_VERSION=7.2.0 \
  JS_Xmx=512m \
  JS_MaxPermSize=256m \
  JS_CATALINA_OPTS="-XX:+UseBiasedLocking -XX:BiasedLockingStartupDelay=0 -XX:+UseParNewGC -XX:+UseConcMarkSweepGC -XX:+DisableExplicitGC -XX:+CMSIncrementalMode -XX:+CMSIncrementalPacing -XX:+CMSParallelRemarkEnabled -XX:+UseCompressedOops -XX:+UseCMSInitiatingOccupancyOnly" \
  JS_DB_TYPE=mysql \
  JS_DB_HOST=jasper.db \
  JS_DB_PORT=3306 \
  JS_DB_USER=jasper \
  JS_DB_PASSWORD=my_password \
  JASPERSERVER_HOME=/jasperserver \
  JASPERSERVER_BUILD=/jasperserver/buildomatic
  
RUN \
  apt-get update \
  && apt-get install -y vim netcat unzip \
    && rm -rf /tmp/* \
    && rm -rf /var/lib/apt/lists/*
  
COPY entrypoint.sh /  
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["run"]
