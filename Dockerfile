FROM memoriaio/java-docker:2022.19.0

MAINTAINER Ismail Marmoush<marmoushismail@gmail.com>

ENV KAFKA_VERSION=3.2.3
ENV KAFKA_FILE="kafka_2.13-${KAFKA_VERSION}"
ENV KAFKA_URL="https://dlcdn.apache.org/kafka/${KAFKA_VERSION}/${KAFKA_FILE}.tgz"

RUN echo "Installing ${KAFKA_FILE}"
RUN curl $KAFKA_URL --output $KAFKA_FILE
RUN tar -xzf $KAFKA_FILE
RUN mv $KAFKA_FILE kafka

ADD main.sh /kafka/main.sh
RUN chmod +x /kafka/main.sh

ADD default.properties /kafka/config/kraft/default.properties

CMD ["bash", "./kafka/main.sh"]