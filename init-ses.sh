
confpath=/usr/share/elasticsearch/config/elasticsearch.yml


if [ -f $confpath ];then
   rm -r $confpath
fi

touch $confpath
echo "cluster.name: ${USER_PID}-${SES_SRV_ID}" >> $confpath
nodeName=${SRV_HOST}
find="."
replace="-"
echo "node.name: ${nodeName//$find/$replace}" >> $confpath
echo "index.number_of_shards: 5" >> $confpath
echo "index.number_of_replicas: 1" >> $confpath

echo "path.data: /usr/share/elasticsearch/data/${USER_PID}/${SES_SRV_ID}/data" >> $confpath

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

ikfolder=/usr/share/elasticsearch/plugins/ik/config/ik

ikpath=$ikfolder/IKAnalyzer.cfg.xml

#append the remote url
echo "<entry key=\"remote_ext_dict\">${IK_EXT_URL}/dict/ext/${USER_PID}/${SES_SRV_ID}/ext.dict</entry>">>$ikpath
echo "<entry key=\"remote_ext_stopwords\">${IK_EXT_URL}/dict/stop/${USER_PID}/${SES_SRV_ID}/stop.dict</entry>">>$ikpath

# start the elasticsearch 

mkdir -vp /usr/share/elasticsearch/data/${USER_PID}/${SES_SRV_ID}/data
chown -R elasticsearch:elasticsearch /usr/share/elasticsearch/data
ls -l /usr/share/elasticsearch/data
#gosu elasticsearch "elasticsearch"
gosu elasticsearch bash -c "elasticsearch"


