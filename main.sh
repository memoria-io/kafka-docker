#!/bin/bash
set -e

set -x
KAFKA_CLUSTER_UUID=${KAFKA_CLUSTER_UUID:-DEFUALT00000000000UUID}

# Config source
CONFIG_TMPL=${CONFIG_TMPL:-/default_tmpl/singleton.properties}

# Generated config
CONFIG=/kafka.properties

#--------------------------------------------------------------------------------------
# Generate configuration files
#--------------------------------------------------------------------------------------
echo "#------------------------" > $CONFIG
echo "# Generated Configuration" >> $CONFIG
echo "#------------------------" >> $CONFIG
envsubst < "$CONFIG_TMPL"  >> $CONFIG
printf "\n" >> $CONFIG
echo "#------------------------" >> $CONFIG
cat $CONFIG

#--------------------------------------------------------------------------------------
# Run kafka
#--------------------------------------------------------------------------------------
./kafka/bin/kafka-storage.sh format -t ${KAFKA_CLUSTER_UUID} -c ${CONFIG} --ignore-formatted
./kafka/bin/kafka-server-start.sh ${CONFIG}
