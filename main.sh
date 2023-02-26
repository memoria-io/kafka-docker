#!/bin/bash
set -e

set -x
KAFKA_CLUSTER_UUID=${KAFKA_CLUSTER_UUID:-DEFUALT00000000000UUID}
CONTROLLER_CONFIG=${CONTROLLER_CONFIG:-/config_tmpl/controller.properties}
BROKER_CONFIG=${BROKER_CONFIG:-/config_tmpl/broker.properties}
SINGLETON_CONFIG=/config_tmpl/singleton.properties
GENERATED_CONFIG=/kafka.properties
set +x

get_config_src() {
  if [ -z "${NUMBER_OF_CONTROLLERS}" ]; then
    echo $SINGLETON_CONFIG
  else
    if (($NODE_ID < ${NUMBER_OF_CONTROLLERS})); then
      echo $CONTROLLER_CONFIG
    else
      echo $BROKER_CONFIG
    fi
  fi
}

extract_id() {
  host_name=$(hostname)
  # e.g kafka-12 becomes: 12
  default_node_id=${host_name##*-}
  if [ -z "${default_node_id}" ] || [ -z "${default_node_id##*[!0-9]*}" ]; then
    default_node_id=0
  fi
  echo "${NODE_ID:-$default_node_id}"
}

#--------------------------------------------------------------------------------------
# Export vars
#--------------------------------------------------------------------------------------
export NODE_ID=$(extract_id)
echo "export NODE_ID=$NODE_ID"

#--------------------------------------------------------------------------------------
# Generate configuration files
#--------------------------------------------------------------------------------------
generate(){
  echo "#------------------------" > $GENERATED_CONFIG
  echo "# Generated Configuration" >> $GENERATED_CONFIG
  echo "#------------------------" >> $GENERATED_CONFIG
  envsubst < "$(get_config_src)" >> $GENERATED_CONFIG
  printf "\n" >> $GENERATED_CONFIG
  echo "#------------------------" >> $GENERATED_CONFIG
  cat $GENERATED_CONFIG
}

#--------------------------------------------------------------------------------------
# Run kafka
#--------------------------------------------------------------------------------------
run(){
  ./kafka/bin/kafka-storage.sh format -t ${KAFKA_CLUSTER_UUID} -c ${GENERATED_CONFIG} --ignore-formatted
  ./kafka/bin/kafka-server-start.sh ${GENERATED_CONFIG}
}

"$@"