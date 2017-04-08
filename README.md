# Event Stream Playground

I started working on this small spare-time project after attending [Fred George](https://twitter.com/fgeorge52?lang=en)'s talk: "_IoT and MicroServices in the Home_". The talk is available on [YouTube](https://youtu.be/J1eTutzcGFQ) and it's strongly recommended!
Another similar talk is [Perryn Fowler](https://twitter.com/perrynfowler)'s
"_Microservices and IoT: A Perfect Match_", also available on [YouTube](https://youtu.be/Am7edhP6G7s). More details are available in the blog post I wrote about it, [here](http://guido-barbaglia.blog/posts/microservices_coreography_with_event_streams.html).

# Usage

This repository is composed by a RabbitMQ server (_the event stream_), and three
Rails 5 apps, mimicking a _Sales_ UI, the _Warehouse_ app and a _Dashboard_. All
these components can be managed throught the scripts stored in `/bin`.

## RabbitMQ
This folder contains the Dockerfile and the commands required to build and
manage a container with a RabbitMQ server instance.

### Build the Container
Docker container is based on Ubuntu 16.04. To build the container run:
```
./bin/rabbit build
```

### Manage the Container
Once the container has been built, it is possible to run it, stop it, or ask for
the status, with:
```
./bin/rabbit start | stop | status
```
The `start` command will try to run the Docker container if this does't exist
yet, otherwise it will restart the existing one.

### Create a new Admin
RabbitMQ has a management web interface, with no default users enabled. To create
a user, simply run:
```
./bin/rabbit add_user my_username my_password
```
After that, navigate to http://localhost:15672/ and use the newly created
credentials to login.

### List of Available Commands

* `build`: Build the Docker image
* `start`: Run RabbitMQ on http://localhost:15672/
* `stop`: Stop RabbitMQ
* `status`: Verify the status of RabbitMQ server
* `add_user <USR> <PWD>`: Add a new <USR> with <PWD> to the RabbitMQ management console

## Rails Apps
Each Rails app is Dockerized through Docker Compose, with a `web` and a `db`
volume. Apps are managed through the `simon_says` script, e.g.
```
./simon_says start sales
```
will start the main sales app and its DB.

### Available Commands
* `start` <APP>: Starts the <APP>
* `initdb` <APP>: Initialize <APP>'s DB
* `resetdb!` <APP>: Reset <APP>'s DB (all existing data will be erased!)
* `sync`: Synchronize DB with RabbitMQ history

### Available Apps
* `dashboard`: Dashboard
* `sales`: EdisonCars
* `warehouse`: Warehouse
