FROM memoriaio/java-docker:19.0.1

MAINTAINER Ismail Marmoush<marmoushismail@gmail.com>

ENV KAFKA_VERSION=3.2.3
ENV KAFKA_FILE="kafka_2.13-${KAFKA_VERSION}"
ENV KAFKA_URL="https://dlcdn.apache.org/kafka/${KAFKA_VERSION}/${KAFKA_FILE}.tgz"

RUN echo "Installing ${KAFKA_FILE}"
RUN curl $KAFKA_URL --output $KAFKA_FILE
RUN tar -xzf $KAFKA_FILE
RUN mv $KAFKA_FILE kafka

ADD main.sh /main.sh
RUN chmod +x /main.sh

ADD kafka_config/singleton.properties /kafka_config/singleton.properties

CMD ["bash","-c", "source ./main.sh && ./main.sh generate && ./main.sh run"]