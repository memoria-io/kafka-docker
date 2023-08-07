# kafka-docker

This Kafka docker uses pure apache kafka source.

The purpose of this image is to run in `kraft` mode aka kafka with Raft, though it's possible to use zk, by using
different configs or replacing the entrypoint, but that's not the scope of this development.

## 1.0 Single instance mode (default configs)

The singleton mode uses default values, since it's usually for test environments, but you can also override such
configs, as mentioned in the configuration section below

```bash
docker run -it --hostname kafka-0 memoriaio/kafka-docker:3.2.0
```

## 2.0 Cluster mode

Cluster mode in kraft has two types of instances, aka two configurations one
for [controller.properties](/default_tmpl/controller.properties) and another for
broker. [broker.properties](/default_tmpl/broker.properties)

```bash
docker compose up
```

## 3.0 Configuration

**Environment variables:**

* `CONFIG_TMPL` directory has default value `/default_tmpl/singleton.properties` which is for singleton mode, when using
  cluster mode make sure to choose controller or broker as used in the [docker-compose file](docker-compose.yaml)
* `KAFKA_CLUSTER_UUID` has default value `DEFUALT00000000000UUID`
    * To generate UUID for the cluster use the following script, and make sure the uuid is same for all containers

```bash
export KAFKA_CLUSTER_UUID=$(./kafka/bin/kafka-storage.sh random-uuid)
```

## 4.0 About variable interpolation support

Very similar to bash interpolation e.g  `${variable_name}` you'll be able to interpolate all system env vars to the
final output.

How it works is basically the main script uses gnu gettext `envsubst < CONFIG_TMPL >> $GENERATED_CONFIG` to generate the
final configuration file.
