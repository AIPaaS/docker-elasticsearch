# Dockerfile

FROM elasticsearch:2.3.3

MAINTAINER dxf 20160706

RUN plugin install mobz/elasticsearch-head 
ADD elasticsearch-analysis-ik-1.9.3.zip /usr/share/elasticsearch/plugins/ik

ADD init-ses.sh /init-ses.sh 
RUN chmod +x /init-ses.sh

EXPOSE 9200 9300

#CMD ["init-ses.sh"]
CMD ["elasticsearch"]
