class RabbitmqClient
  class << self
    def listen(message2order:)
      consume('warehouse', message2order, false)
    end

    def sync(message2order:)
      consume('history', message2order, true)
    end

    private

    def consume(queue_name, message2order, block)
      connection  = open_connection
      channel     = connection.create_channel
      exchange    = channel.fanout('orders', :durable => true)
      queue       = channel.queue(queue_name, :auto_delete => false)
      queue.bind(exchange)

      begin
        queue.subscribe(:block => block, :manual_ack => true) do |delivery_info, properties, body|
          json = JSON.parse(body)
          if Order.find_by_external_id(json['external_id']).nil?
            order_date  = message2order.call(json)
            order       = Order.new(order_date)

            order.save
            puts "NEW ORDER ADDED: #{json['external_id']}" if block
          end
        end
      rescue Interrupt => _
        channel.close
        connection.close
      end
    end

    def open_connection
      connection = Bunny.new(connection_parameters)
      connection.start

      connection
    end

    def connection_parameters
      {
        :host => ENV['RABBITMQ_IP'],
        :user => ENV['RABBITMQ_USR'],
        :pass => ENV['RABBITMQ_PWD']
      }
    end
  end
end
