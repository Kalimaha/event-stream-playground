# Event Stream Playground

I started working on this small spare-time project after attending [Fred George](https://twitter.com/fgeorge52?lang=en)'s talk: "_IoT and MicroServices in the Home_". The talk is available on [YouTube](https://youtu.be/J1eTutzcGFQ) and I highly recommend it!

## Use Case

Someone decided to compete with Tesla in the electric cars market with a low cost alternative named "Edison Cars". This young company needs an e-commerce web-site to sell its products, and it wants to streamline the whole operation by starting the production of a new car as soon as an order is placed. Basically, they need to share data between sales and the other divisions of the company. There are several ways to achieve such goal.

### Monolith

Well. No. 😬

### Synchronous RESTful Services

We can implement several micro services, one for each division. As soon as a customer buys a new car, we create a new record in the consumer-facing app, and we then send such data to every other downstream system. This will put too much responsibility in the sales web-app, that needs to know which are the services required to build and ship a car, and how to contact them.

### Queue

Another solution consists in the usage of a queue, such as [SQS](https://aws.amazon.com/sqs/), [Que](https://github.com/chanks/que) or similar. With this implementation, the sole responsibility of the sales app is to (_sell a car and_) enqueue the data about the sale. Such information is then retrieved and processed by a worker. Usually a queue works for a single worker, which removes the job from the queue, and therefore this is not a good solution if we want to share the same information between several services

### Data Feed

The sales app can also produce a data feed, exposing an endpoint which provides all the sales in JSON/XML format to whoever needs it. Downstream systems can consume such feed on a regular basis and store the data in a local DB. With this solution, the sales app is only responsible for selling cars, we can share the same information among several systems, and we also increase the resilience of the overall architecture. Each consumer has a local copy of the data, and hypothetical downtimes of the sales app won't affect the production of the cars.

This solution works well when data is not updated often and the local copy is good enough to continue operations. On the other hand, we are stressing the sales app which is accessed often to provide fresh data. This can potentially slow down the app when there are many downstream system and/or the feed is particularly heavy.

### Event Stream

With an event stream, the sales app is required to pubilsh the sale event and the relative data to a message broker. Downstream systems subscribe to the event stream and get notified every time there is a new event. The advantages are the same of the Data Feed solution, but we have added an extra layer between the data source and its consumers. The message broker is an external system, therefore the sales app is not queried constantly. Consumer systems read directly from the stream and store the data locally, achievieng the same decoupling and resiliency goals.

## RabbitMQ Overview

I've tried RabbitMQ, as suggested in the talk, with the [Bunny](http://rubybunny.info/) Ruby client. For each new sale, a new record is stored in the DB and the event published on the [exchange](https://www.rabbitmq.com/tutorials/tutorial-three-ruby.html). Basically, an exchange is an object that receives messages and pushes them to queues:

```ruby
def publish(order:)
  connection  = open_connection
  channel     = connection.create_channel
  exchange    = channel.fanout('orders', :durable => true)
  message     = create_message(order)

  exchange.publish(message, :persistent => true)

  connection.close
end
```
The data source needs to open a connection, create a channel, an exchange and then publish the message. The code on the consumer side is very similar:

```ruby
def consume(queue_name, block)
  connection  = open_connection
  channel     = connection.create_channel
  exchange    = channel.fanout('orders', :durable => true)
  queue       = channel.queue(queue_name, :auto_delete => false)
  queue.bind(exchange)

  begin
    queue.subscribe(:block => block, :manual_ack => true) do |delivery_info, properties, body|
      json = JSON.parse(body)
      if Order.find_by_external_id(json['external_id']).nil?
        order = Order.new(order_data(json))
        order.save
      end
    end
  rescue Interrupt => _
    channel.close
    connection.close
  end
end
```

## RabbitMQ Disadvantages

* __Order matters:__ if you publish a message to the exchange with no existing queue, the message is discarded, lost. The solution that I've implemented so far is to create a queue in the datasource, named `history`. Basically, the data source produces the data, it publishes it to the exchange, but it also "consumes" it in a backup queue.
* __Adding Consumers:__ when a new consumer subscribes to the exchange, it reads the data from that moment on. To solve this problem, I added a small `rake` task, that subscribe to the aforementioned `history` queue, and populates the DB. This is the same as having a feed, even though we are still dealing with the event stream with no overhead for the datasource.
