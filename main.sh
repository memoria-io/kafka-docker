#!/bin/bash
SERVER_CONFIG_FILE=/kafka/config.properties
PREFIX=KAFKA_CONFIG_
set +x
set -e

host_name=$(hostname)
# e.g kafka-12 becomes: 12
nodeId=${host_name##*-}

if [ -z "${nodeId}" ];
then
  export KAFKA_CONFIG_node_id="0"
else
  export KAFKA_CONFIG_node_id=$nodeId
fi

echo "Node id: ${KAFKA_CONFIG_node_id}"

echo "######## Kafka Configuration #########" > $SERVER_CONFIG_FILE
env | grep "^${PREFIX}" | \
 awk -F $PREFIX '{print $2}' | \
 sed -e ':b; s/^\([^=]*\)*__/\1\##/; tb;' | \
 sed -e ':b; s/^\([^=]*\)*_/\1\./; tb;' | \
 sed -e ':b; s/^\([^=]*\)*##/\1\_/; tb;' >> $SERVER_CONFIG_FILE

echo "---------------------------------"
echo "Kafka Configuration at ${SERVER_CONFIG_FILE}"
echo "---------------------------------"
cat $SERVER_CONFIG_FILE
echo "---------------------------------"

export KAFKA_NODE_UUID=$(./kafka/bin/kafka-storage.sh random-uuid)
./kafka/bin/kafka-storage.sh format -t ${KAFKA_NODE_UUID} -c ${SERVER_CONFIG_FILE}
./kafka/bin/kafka-server-start.sh ${SERVER_CONFIG_FILE}