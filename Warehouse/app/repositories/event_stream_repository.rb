class EventStreamRepository
  class << self
    RABBITMQ_IP   = '192.168.1.245'
    RABBITMQ_USR  = 'kalimarabbit'
    RABBITMQ_PWD  = '123456'

    def listen
      consume('dashboard', false)
    end

    def sync
      consume('history', true)
    end

    private

    def consume(queue_name, block)
      puts 'Listen to event stream: START'

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

            # TODO: to remove or not to remove it?
            # TODO: Maybe it'd be better not to remove it and have RabbitMQ to
            # TODO: periodically 'clean' the exchange
            # channel.reject(delivery_info.delivery_tag)
          end
        end
      rescue Interrupt => _
        channel.close
        connection.close
      end
    end

    def order_data(json)
      {
        external_id: json['external_id'],
        name: json['name'],
        batteries: json['batteries'],
        order_date: json['order_date'],
        delivery_date: json['delivery_date'],
      }
    end

    def open_connection
      connection = Bunny.new(connection_parameters)
      connection.start

      connection
    end

    def connection_parameters
      {
        :host => RABBITMQ_IP,
        :user => RABBITMQ_USR,
        :pass => RABBITMQ_PWD
      }
    end
  end
end