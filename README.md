# kafka-docker

This Kafka docker uses pure apache kafka source.

The purpose of this image is to run in `kraft` mode aka kafka with Raft, though it's possible to use zk, by using
different configs or replacing the entrypoint, but that's not the scope of this development.

## 1.0 Single instance mode (default configs)

```bash
docker run -it --hostname kafka-0 memoriaio/kafka-docker:3.2.0
```

## 2.0 Configuration

* `CONFIG_TMPL` has default value `/default_tmpl/singleton.properties`
* `KAFKA_CLUSTER_UUID` has default value `DEFUALT00000000000UUID`
    * To generate UUID for the cluster, and make sure the uuid is same for all containers

```bash
export KAFKA_CLUSTER_UUID=$(./kafka/bin/kafka-storage.sh random-uuid)
```

## 3.0 Cluster mode

```bash
docker compose up
```

## 4.0 Variable interpolation

The main script uses gnu gettext `envsubst < CONFIG_TMPL >> $GENERATED_CONFIG` to generate the final configuration
file, this does environment variable substitution.
