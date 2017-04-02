class EventStreamRepository
  class << self
    RABBITMQ_IP   = ENV['RABBITMQ_IP']
    RABBITMQ_USR  = ENV['RABBITMQ_USR']
    RABBITMQ_PWD  = ENV['RABBITMQ_PWD']

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
