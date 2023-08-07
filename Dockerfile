FROM memoriaio/java-docker:19.0.1

MAINTAINER Ismail Marmoush<marmoushismail@gmail.com>

ENV KAFKA_VERSION=3.5.1
ENV KAFKA_FILE="kafka_2.13-${KAFKA_VERSION}"
ENV KAFKA_URL="https://dlcdn.apache.org/kafka/${KAFKA_VERSION}/${KAFKA_FILE}.tgz"

RUN echo "Installing ${KAFKA_FILE}"
RUN curl $KAFKA_URL --output $KAFKA_FILE
RUN tar -xzf $KAFKA_FILE
RUN mv $KAFKA_FILE kafka

ADD main.sh /main.sh
RUN chmod +x /main.sh

ADD default_tmpl/ /default_tmpl/

CMD ["bash", "./main.sh"]