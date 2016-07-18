path=/${USER_PID}
mkdir -vp $path/conf
confpath=$path/conf/${USER_PID}-${SES_SRV_ID}-${SRV_PORT}.yml


if [ -f $confpath ];then
   rm -r $confpath
fi

touch $confpath
echo "cluster.name: ${USER_PID}-${SES_SRV_ID}" >> $confpath
#echo "node.name: "${SRV_HOST}"" >> $confpath
echo "index.number_of_shards: 5" >> $confpath
echo "index.number_of_replicas: 1" >> $confpath

echo "path.data: /usr/share/elasticsearch/data" >> $confpath

echo "network.bind_host: ${SRV_HOST}" >> $confpath
echo "network.publish_host: ${SRV_HOST}" >> $confpath
echo "network.host: ${SRV_HOST}" >> $confpath
echo "transport.tcp.port: ${SRV_PORT}" >> $confpath
echo "http.port: ${SRV_HTTP_PORT}" >> $confpath
echo "index.mapper.dynamic : false" >> $confpath
echo "threadpool.bulk.type: fixed" >> $confpath
echo "threadpool.bulk.size: 8" >> $confpath 
echo "threadpool.bulk.queue_size: 500" >> $confpath
echo "node.master: true" >> $confpath
echo "node.data: true" >> $confpath
echo "discovery.zen.ping.multicast.enabled: false" >> $confpath
echo "discovery.zen.ping.unicast.hosts: [${SES_CLUSTER}]"  >> $confpath
echo "index:" >> $confpath
echo "  analysis:" >> $confpath
echo "    analyzer:" >> $confpath
echo "      ik:" >> $confpath
echo "          alias: [ik_analyzer]" >> $confpath
echo "          type: org.elasticsearch.index.analysis.IkAnalyzerProvider" >> $confpath
echo "      ik_max_word:" >> $confpath
echo "          type: ik" >> $confpath
echo "          use_smart: false" >> $confpath
echo "      ik_smart:" >> $confpath
echo "          type: ik" >> $confpath
echo "          use_smart: true" >> $confpath
echo "      ik_tt_${USER_PID}_${SES_SRV_ID}:" >> $confpath
echo "          type: ik" >> $confpath
echo "          use_smart: fasle" >> $confpath
ikfolder=/usr/share/elasticsearch/config/ik/${USER_PID}/${SES_SRV_ID}
mkdir -vp $ikfolder
ikpath=$ikfolder/IKAnalyzer.cfg.xml
#> $ikfolder/${SES_SRV_ID}_index.dic
#> $ikfolder/${SES_SRV_ID}_stop.dic
> $ikpath
echo '<?xml version="1.0" encoding="UTF-8"?>' >> $ikpath
echo '<!DOCTYPE properties SYSTEM "http://java.sun.com/dtd/properties.dtd">' >> $ikpath
echo '<properties>' >> $ikpath
echo "<entry key=\"ext_dict\">${USER_PID}/${SES_SRV_ID}/${SES_SRV_ID}_index.dic</entry>" >> $ikpath
echo "<entry key=\"ext_stopwords\">${USER_PID}/${SES_SRV_ID}/${SES_SRV_ID}_stop.dic</entry>
</properties>" >> $ikpath

# start the elasticsearch 
chown -R elasticsearch:elasticsearch /${USER_PID}
cp -f ${confpath} /usr/share/elasticsearch/config/elasticsearch.yml
ls -l ${confpath}
mkdir -vp /usr/share/elasticsearch/data/${USER_PID}-${SES_SRV_ID}
chown -R elasticsearch:elasticsearch /usr/share/elasticsearch/data
ls -l /usr/share/elasticsearch/data
#gosu elasticsearch "elasticsearch"
gosu elasticsearch bash -c "elasticsearch"


