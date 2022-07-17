# kafka-docker
This Kafka docker uses apache kafka
The default configs runs in kraft mode (no zookeeper mode), yet it can be used with normal zk instances. 

## Quick usage

* To run directly from docker-hub

```bash
docker run -it --env-file default_env --hostname kafka-0 memoriaio/kafka-docker:3.2.0
```

* To build and run locally

```bash
docker build --build-arg KAFKA_VERSION=3.2.0 -t local/kafka:3.2.0 .
```

* To run with defaults, and node.id=0

```bash
docker run -it --env-file default_env --hostname kafka-0 local/kafka:3.2.0
```

## Configuration notes

* To generate UUID for the cluster, and make sure the uuid is same for all containers

```bash
export KAFKA_CLUSTER_UUID=$(./kafka/bin/kafka-storage.sh random-uuid)
```

* The helper script `main.sh` replaces `_` with `.` and `__` with `_` for all environment variables that start with the
  prefix `KAFKA_CONFIG_` after deleting the prefix, p.s this replacement doesn't affect the values.  