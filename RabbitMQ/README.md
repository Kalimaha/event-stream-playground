# RabbitMQ Server
This folder contains the Dockerfile and the commands required to build and
manage a container with a RabbitMQ server instance.

## Build the Container
Docker container is based on Ubuntu 16.04. To build the container run:
```
./bin/rabbit build
```

## Manage the Container
Once the container has been built, it is possible to run it, stop it, or ask for
the status, with:
```
./bin/rabbit start | stop | status
```
The `start` command will try to run the Docker container if this does't exist
yet, otherwise it will restart the existing one.

## Create a new Admin
RabbitMQ has a management web interface, with no default users enabled. To create
a user, simply run:
```
./bin/rabbit add_user my_username my_password
```
After that, navigate to http://localhost:15672/ and use the newly created
credentials to login.

## List of Available Commands

* `build`: Build the Docker image
* `start`: Run RabbitMQ on http://localhost:15672/
* `stop`: Stop RabbitMQ
* `status`: Verify the status of RabbitMQ server
* `add_user <USR> <PWD>`: Add a new <USR> with <PWD> to the RabbitMQ management console
