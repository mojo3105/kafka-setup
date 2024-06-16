# Base image with Java and Alpine Linux
FROM adoptopenjdk:8-jdk-hotspot-bionic

# Set Kafka and Scala versions
ARG KAFKA_VERSION=2.8.0
ARG SCALA_VERSION=2.13

# Install required dependencies
RUN apt-get update && \
    apt-get install -y wget bash && \
    rm -rf /var/lib/apt/lists/*

# Download and extract Kafka
RUN wget -q "https://downloads.apache.org/kafka/${KAFKA_VERSION}/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz" && \
    mkdir /kafka && \
    tar -xzf "kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz" --strip-components=1 -C /kafka && \
    rm "kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz"

# Set Kafka and ZooKeeper configurations
COPY config/server.properties /kafka/config/
# Expose Kafka and ZooKeeper ports
EXPOSE 9092 2181

# Start ZooKeeper and then Kafka
CMD /zookeeper/bin/zkServer.sh start && sleep 3 && /kafka/bin/kafka-server-start.sh /kafka/config/server.properties
