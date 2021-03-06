FROM openjdk:8-jre

ENV KAFKA_HOME=/kafka
ENV PATH=${PATH}:${KAFKA_HOME}/bin

RUN curl "https://downloads.apache.org/kafka/2.5.0/kafka_2.13-2.5.0.tgz" -o kafka.tgz
RUN tar xfz kafka.tgz
RUN rm /kafka.tgz
RUN mv kafka_*/ $KAFKA_HOME
