# Dockerfile

FROM elasticsearch:2.3.4

MAINTAINER dxf 20160706

RUN plugin install mobz/elasticsearch-head
RUN mkdir  /usr/share/elasticsearch/plugins/ik
ADD elasticsearch-analysis-ik-1.9.4.zip /usr/share/elasticsearch/plugins/ik/

RUN cd /etc && rm -f localtime && ln -s  /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
ADD logging.yml /usr/share/elasticsearch/config/
RUN cd /usr/share/elasticsearch/plugins/ik && unzip elasticsearch-analysis-ik-1.9.4.zip && rm -fr elasticsearch-analysis-ik-1.9.4.zip && cd /
ADD IKAnalyzer.cfg.xml /usr/share/elasticsearch/plugins/ik/config/IKAnalyzer.cfg.xml
ADD init-ses.sh /init-ses.sh 
RUN chmod +x /init-ses.sh

EXPOSE 9200 9300
ENV PATH /init-ses.sh:$PATH

CMD ["/init-ses.sh"]
#CMD ["elasticsearch"]
