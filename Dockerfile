FROM openjdk:11-jre-slim-sid

ARG EXPORTER_VERSION=0.9.6
ARG EXPORTER_SHA512=8d39b4a2f16f241c10ee1afbac1d8ff8612b01dab5854839c7aa559282a0bdecad4f1aa3ae2dd66232de877acbecc48236dab61efbdc28bf9868b43c4c650580

RUN apt-get update && apt-get install -y --no-install-recommends \
		netcat \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /etc/cassandra-exporter /opt/cassandra-exporter
ADD https://github.com/Yelp/dumb-init/releases/download/v1.2.1/dumb-init_1.2.1_amd64 /sbin/dumb-init
ADD https://github.com/instaclustr/cassandra-exporter/releases/download/v${EXPORTER_VERSION}/cassandra-exporter-standalone-${EXPORTER_VERSION}.jar /opt/cassandra-exporter/cassandra-exporter.jar
RUN echo "${EXPORTER_SHA512}  /opt/cassandra-exporter/cassandra-exporter.jar" > sha512_checksum.txt && sha512sum -c sha512_checksum.txt
ADD config /etc/cassandra-exporter/
ADD run.sh /

RUN chmod +x /sbin/dumb-init && chmod g+wrx -R /opt/cassandra-exporter && chmod g+wrx -R /etc/cassandra-exporter

CMD ["/sbin/dumb-init", "/bin/bash", "/run.sh"]