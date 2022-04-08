FROM memoriaio/java-docker

MAINTAINER Ismail Marmoush<marmoushismail@gmail.com>

RUN apt-get update && apt-get install -y curl apt-utils man nano
ENV KAFKA_FILE="kafka_2.12-3.1.0.tgz"
ENV KAFKA_URL="https://dlcdn.apache.org/kafka/3.1.0/${KAFKA_FILE}"
RUN curl $KAFKA_URL --output $KAFKA_FILE
RUN tar -xzf $KAFKA_FILE
