# kafka-docker

This Kafka docker uses pure apache kafka source.

The purpose of this image is to run in `kraft` mode aka kafka with Raft, though it's possible to use zk, by using
different configs or replacing the entrypoint, but that's not the scope of this development.

## 1.0 Single instance mode (default configs)

```bash
docker run -it --hostname kafka-0 memoriaio/kafka-docker:3.2.0
```

## 2.0 Cluster mode (custom configs)

### Required Configuration

* `CONTROLLERS_COUNT` set to bigger than 0, required and has no default value
* `CONTROLLER_CONFIG` has default value `/kafka/config/kraft/controller.properties`
* `BROKER_CONFIG` has default value `/kafka/config/kraft/broker.properties`
* Setting `--hostname "whatever_name-${id}` where `${id}` becomes the kafka `node.id` using `node.id=$(extract_id)`

Example:

If `CONTROLLERS_COUNT=3` then containers with hostnames `my-kafkatt-0`, `hello-kafkaaa-1`, `hi-kafka-2` will run
using `CONTROLLER_CONFIG` while `my-kafkaaaa-3`, `any-kafkabbb-4` , `my-kafkass-...` will run using the `BROKER_CONFIG`.

### Optional configuration

* To generate UUID for the cluster, and make sure the uuid is same for all containers

```bash
export KAFKA_CLUSTER_UUID=$(./kafka/bin/kafka-storage.sh random-uuid)
```

### Running example

```bash
id=0 # where id can be 0,1,2,...

docker run -it -e CONTROLLERS_COUNT=3 \
  -e CONTROLLER_CONFIG=/some_path/controller.properties \
  -e BROKER_CONFIG=/some_path/broker.properties \
  -e CONTROLLERS_COUNT=3 \
  -v some_path:some_path \
  --hostname "kafka-${id}" \
  local/kafka:3.2.0
```

### Variable interpolation

The main script uses gnu gettext `envsubst < $(get_config_src) > $GENERATED_CONFIG` to generate the final configuration
file, this does environment variable substitution.

One example is already used with the `default.properties` file  `node.id=${NODE_ID}`, which evaluates NODE_ID from the
environment and the output is written to `generated.properties`

## 3.0 Build from source

```bash
docker build --build-arg KAFKA_VERSION=3.2.0 -t local/kafka:3.2.0 .
```
