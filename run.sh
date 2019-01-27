#!/bin/bash

set -e

export JVM_OPTS="${JVM_OPTS}"

echo "Starting Cassandra exporter"
echo "JVM_OPTS: $JVM_OPTS"

# host=$(grep -Po "jmx-service-url[^\ ]+" | cut -d '=' -f 2 | grep -Po "[\w]+:[\d]+" | cut -d ':' -f 1)
# port=$(grep -Po "jmx-service-url[^\ ]+" | cut -d '=' -f 2 | grep -Po "[\w]+:[\d]+" | cut -d ':' -f 2)

# # echo --jmx-service-url='service:jmx:rmi:///jndi/rmi://localhost:7199/jmxrmi' | grep -Po "(?<=listen\=)[\d.:]+"
# while ! nc -z $host $port; do
#   echo "Waiting for Cassandra JMX to start on $host:$port"
#   sleep 1
# done

/sbin/dumb-init /usr/bin/java ${JVM_OPTS} -jar /opt/cassandra-exporter/cassandra-exporter.jar @/etc/cassandra-exporter/config