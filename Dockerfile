FROM memoriaio/java-docker
ARG KAFKA_VERSION

MAINTAINER Ismail Marmoush<marmoushismail@gmail.com>

RUN apt-get update && apt-get install -y curl apt-utils man nano
ENV KAFKA_FILE="kafka_2.13-${KAFKA_VERSION}.tgz"
RUN echo "Installing ${KAFKA_FILE}"
ENV KAFKA_URL="https://archive.apache.org/dist/kafka/${KAFKA_VERSION}/${KAFKA_FILE}"

RUN curl $KAFKA_URL --output $KAFKA_FILE
RUN tar -xzf $KAFKA_FILE
