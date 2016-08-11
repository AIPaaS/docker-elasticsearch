
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

ikConfig=/usr/share/elasticsearch/plugins/ik/config/ik/IKAnalyzer.cfg.xml
ik_ext_url=${IK_EXT_URL}
last_char=${IK_EXT_URL: -1}
#judge 
if [[ "$last_char" == "/" ]]; then
    ik_ext_url=${IK_EXT_URL%?}
fi
	
ext_dict=$(echo "${ik_ext_url}/dict/ext/${USER_PID}/${SES_SRV_ID}/ext.dict" )
stop_dict=$(echo "${ik_ext_url}/dict/stop/${USER_PID}/${SES_SRV_ID}/stop.dict")
#append the remote url
sed -i -e "s@___ext_dict___@${ext_dict}@g" $ikConfig
sed -i -e "s@___stop_dict___@${stop_dict}@g" $ikConfig

# start the elasticsearch 

mkdir -vp /usr/share/elasticsearch/data/${USER_PID}/${SES_SRV_ID}/data
chown -R elasticsearch:elasticsearch /usr/share/elasticsearch/data
ls -l /usr/share/elasticsearch/data
#gosu elasticsearch "elasticsearch"
gosu elasticsearch bash -c "elasticsearch"


