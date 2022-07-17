#!/bin/bash
set -e

SERVER_CONFIG_FILE=/kafka/config.properties
PREFIX=KAFKA_CONFIG_

#--------------------------------------------------------------------------------------
# Setting Kafka node.id
#--------------------------------------------------------------------------------------
host_name=$(hostname)
# e.g kafka-12 becomes: 12
default_node_id=${host_name##*-}

if [ -z "${default_node_id}" ] || [ -z "${default_node_id##*[!0-9]*}" ];
then
  default_node_id=0
fi

export KAFKA_CONFIG_node_id="${KAFKA_CONFIG_node_id:-$default_node_id}"

#--------------------------------------------------------------------------------------
# Creating configuration file
#--------------------------------------------------------------------------------------
echo "#-----------------------------------" > $SERVER_CONFIG_FILE
echo "# Generated Kafka Configuration     " >> $SERVER_CONFIG_FILE
echo "#-----------------------------------" >> $SERVER_CONFIG_FILE
env | grep "^${PREFIX}" | \
 awk -F $PREFIX '{print $2}' | \
 sed -e ':b; s/^\([^=]*\)*__/\1\##/; tb;' | \
 sed -e ':b; s/^\([^=]*\)*_/\1\./; tb;' | \
 sed -e ':b; s/^\([^=]*\)*##/\1\_/; tb;' >> $SERVER_CONFIG_FILE

cat $SERVER_CONFIG_FILE
echo "---------------------------------"

#--------------------------------------------------------------------------------------
# Setting kafka cluster UUID
#--------------------------------------------------------------------------------------
if [ -z "${KAFKA_CLUSTER_UUID}" ];
then
  echo "KAFKA_CLUSTER_UUID was not set, using arbitrary default uuid: A0acq9cPQwymi60FufxF7g"
  export KAFKA_CLUSTER_UUID=A0acq9cPQwymi60FufxF7g
fi
echo "---------------------------------"

#--------------------------------------------------------------------------------------
# Running kafka
#--------------------------------------------------------------------------------------
#./kafka/bin/kafka-storage.sh format -t ${KAFKA_CLUSTER_UUID} -c ${SERVER_CONFIG_FILE}
#./kafka/bin/kafka-server-start.sh ${SERVER_CONFIG_FILE}