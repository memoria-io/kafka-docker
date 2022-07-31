#!/bin/bash
set -e

set -x
KAFKA_CLUSTER_UUID=${KAFKA_CLUSTER_UUID:-DEFUALT00000000000UUID}
CONTROLLER_CONFIG=${CONTROLLER_CONFIG:-/kafka/config/kraft/controller.properties}
BROKER_CONFIG=${BROKER_CONFIG:-/kafka/config/kraft/broker.properties}
FINAL_CONFIG=${FINAL_CONFIG:-/kafka/config/kraft/final_config.properties}


set +x

run_default() {
  echo "CONTROLLERS_COUNT is not set, using default.properties configurations"
  export NODE_ID=$(host_count)

  DEFAULT_CONFIG=/kafka/default.properties
  FINAL_DEFAULT_CONFIG=/kafka/final-default.properties
  envsubst < $DEFAULT_CONFIG > $FINAL_DEFAULT_CONFIG

  ./kafka/bin/kafka-storage.sh format -t ${KAFKA_CLUSTER_UUID} -c ${FINAL_DEFAULT_CONFIG}

  echo "Running kafka with configurations in: $FINAL_DEFAULT_CONFIG"
  cat $FINAL_DEFAULT_CONFIG
  ./kafka/bin/kafka-server-start.sh ${FINAL_DEFAULT_CONFIG}
}

run_with_count() {
  echo "CONTROLLERS_COUNT=${CONTROLLERS_COUNT}"
  export NODE_ID=$(host_count)
  if (($NODE_ID < ${CONTROLLERS_COUNT})); then
    echo "Running kafka container as a controller"
    config_file=$CONTROLLER_CONFIG
  else
    echo "Running kafka container as a broker"
    config_file=$BROKER_CONFIG
  fi
  envsubst < $config_file > $FINAL_CONFIG


  ./kafka/bin/kafka-storage.sh format -t ${KAFKA_CLUSTER_UUID} -c ${FINAL_CONFIG}

  echo "Running kafka with configurations in: $FINAL_CONFIG"
  cat $FINAL_CONFIG
  ./kafka/bin/kafka-server-start.sh ${FINAL_CONFIG}
}

host_count() {
  config_file=$1
  host_name=$(hostname)

  # e.g kafka-12 becomes: 12
  default_node_id=${host_name##*-}

  if [ -z "${default_node_id}" ] || [ -z "${default_node_id##*[!0-9]*}" ]; then
    default_node_id=0
  fi

  echo "${NODE_ID:-$default_node_id}"
}

#--------------------------------------------------------------------------------------
# Run
#--------------------------------------------------------------------------------------

if [ -z "${CONTROLLERS_COUNT}" ]; then
  run_default
else
  run_with_count
fi
