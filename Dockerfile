FROM memoriaio/java-docker:18

MAINTAINER Ismail Marmoush<marmoushismail@gmail.com>

ARG KAFKA_VERSION
ENV KAFKA_FILE="kafka_2.13-${KAFKA_VERSION}"
ENV KAFKA_URL="https://dlcdn.apache.org/kafka/${KAFKA_VERSION}/${KAFKA_FILE}.tgz"

RUN apt-get update && apt-get install -y curl apt-utils man nano
RUN echo "Installing ${KAFKA_FILE}"
RUN curl $KAFKA_URL --output $KAFKA_FILE
RUN tar -xzf $KAFKA_FILE
RUN mv $KAFKA_FILE kafka
ADD main.sh /kafka/main.sh
RUN chmod +x /kafka/main.sh

CMD ["bash", "./kafka/main.sh"]