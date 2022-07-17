# kafka-docker

## For user
```bash
docker run -it --env-file default_env --hostname kafka-0 memoriaio/kafka-docker:3.2.0
```


##  For committer
```bash
docker build --build-arg KAFKA_VERSION=3.2.0 -t local/kafka:3.2.0 .
```

## To run with defaults, and node.id=0

```bash
docker run -it --env-file default_env --hostname kafka-0 local/kafka:3.2.0
```