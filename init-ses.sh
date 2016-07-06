path=/${USER_PID}
mkdir -vp $path/{conf,data}
confpath=$path/conf/${USER_PID}-${SES_SRV_ID}-${SRV_PORT}.yml


if [ -f $confpath ];then
   rm -r $confpath
fi

touch $confpath
echo "cluster.name: ${USER_PID}-${SES_SRV_ID}" >> $confpath
#echo "node.name: "${SRV_HOST}"" >> $confpath
echo "index.number_of_shards: 5" >> $confpath
echo "index.number_of_replicas: 1" >> $confpath

echo "path.data: $path/data" >> $confpath

echo "network.bind_host: $3" >> $confpath
echo "network.publish_host: $3" >> $confpath
echo "network.host: $3" >> $confpath
echo "transport.tcp.port: $4" >> $confpath
echo "http.port: $5" >> $confpath
echo "index.mapper.dynamic : false" >> $confpath
echo "threadpool.bulk.type: fixed" >> $confpath
echo "threadpool.bulk.size: 8" >> $confpath 
echo "threadpool.bulk.queue_size: 500" >> $confpath
echo "node.master: true" >> $confpath
echo "node.data: true" >> $confpath
echo "discovery.zen.ping.multicast.enabled: false" >> $confpath
echo "discovery.zen.ping.unicast.hosts: [$7]"  >> $confpath
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
echo "      ik_tt_$1_$6:" >> $confpath
echo "          type: ik" >> $confpath
echo "          use_smart: fasle" >> $confpath
ikfolder=$HOME/elasticsearch-1.7.1/config/ik/$1/$6
mkdir -vp $ikfolder
ikpath=$ikfolder/IKAnalyzer.cfg.xml
> $ikfolder/$6_index.dic
> $ikfolder/$6_stop.dic
> $ikpath
echo '<?xml version="1.0" encoding="UTF-8"?>' >> $ikpath
echo '<!DOCTYPE properties SYSTEM "http://java.sun.com/dtd/properties.dtd">' >> $ikpath
echo '<properties>' >> $ikpath
echo "<entry key=\"ext_dict\">$1/$6/$6_index.dic</entry>" >> $ikpath
echo "<entry key=\"ext_stopwords\">$1/$6/$6_stop.dic</entry>
</properties>" >> $ikpath

