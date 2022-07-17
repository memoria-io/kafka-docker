# kafka-docker

## To build
```bash
docker build --build-arg KAFKA_VERSION=3.2.0 -t local/kafka:3.2.0 .
```

## To run

```bash
docker run -it --env-file default_env local/kafka:3.2.0 bash
```