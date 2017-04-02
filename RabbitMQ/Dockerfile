# Create a container from Ubuntu
FROM ubuntu:16.04

# Credits.
MAINTAINER Guido Barbaglia "guido.barbaglia@gmail.com"

# Update Ubuntu repositories
RUN apt-get update

# Install RabbitMQ server
RUN apt-get install -y rabbitmq-server

# Enable the management plugin
RUN rabbitmq-plugins enable rabbitmq_management

# Expose ports
EXPOSE 5672 15672

# Define RabbitMQ's entry point
ENTRYPOINT /usr/sbin/rabbitmq-server
