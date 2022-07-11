#!/bin/bash
UUID=A0acq9cPQwymi60FufxF7g
SERVER_CONFIG_FILE=/kafka/config.properties
PREFIX=KAFKA_CONFIG_

echo "######## Kafka Configuration #########" > $SERVER_CONFIG_FILE
env | grep "^${PREFIX}" | awk -F $PREFIX '{print $2}' >> $SERVER_CONFIG_FILE

#./kafka/bin/kafka-storage.sh random-uuid
./kafka/bin/kafka-storage.sh format -t ${UUID} -c ${SERVER_CONFIG_FILE}
./kafka/bin/kafka-server-start.sh ${SERVER_CONFIG_FILE}