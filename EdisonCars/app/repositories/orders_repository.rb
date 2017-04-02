class OrdersRepository
  class << self
    def create(order_data:)
      order = Order.new(order_data)
      order.save

      order
    end
  end
end
