# Dockerfile

FROM elasticsearch:2.3.3

MAINTAINER dxf 20160706

RUN plugin install mobz/elasticsearch-head
RUN mkdir  /usr/share/elasticsearch/plugins/ik
ADD elasticsearch-analysis-ik-1.9.3.zip /usr/share/elasticsearch/plugins/ik/elasticsearch-analysis-ik-1.9.3.zip \
&& unzip /usr/share/elasticsearch/plugins/ik/elasticsearch-analysis-ik-1.9.3.zip \
&& rm -fr /usr/share/elasticsearch/plugins/ik/elasticsearch-analysis-ik-1.9.3.zip

ADD init-ses.sh /init-ses.sh 
RUN chmod +x /init-ses.sh

EXPOSE 9200 9300

#CMD ["init-ses.sh"]
CMD ["elasticsearch"]
