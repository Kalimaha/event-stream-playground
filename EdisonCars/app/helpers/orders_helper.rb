module OrdersHelper
  def self.model_f
    {
      external_id: SecureRandom.uuid,
      name: 'Model F',
      autonomy: '100km',
      top_speed: '60 km/h',
      batteries: 10,
      price: 19900,
      order_date: Date.today,
      delivery_date: 3.months.from_now,
      customer_name: 'Guido Barbaglia',
      customer_address: 'Melbourne, VIC, Australia',
      customer_credit_card_number: '1234-5678-1234-5678'
    }
  end

  def self.model_p
    {
      external_id: SecureRandom.uuid,
      name: 'Model P',
      autonomy: '150km',
      top_speed: '80 km/h',
      batteries: 20,
      price: 29900,
      order_date: Date.today,
      delivery_date: 6.months.from_now,
      customer_name: 'Guido Barbaglia',
      customer_address: 'Melbourne, VIC, Australia',
      customer_credit_card_number: '1234-5678-1234-5678'
    }
  end

  def self.model_h
    {
      external_id: SecureRandom.uuid,
      name: 'Model H',
      autonomy: '250km',
      top_speed: '120 km/h',
      batteries: 100,
      price: 49900,
      order_date: Date.today,
      delivery_date: 1.year.from_now,
      customer_name: 'Guido Barbaglia',
      customer_address: 'Melbourne, VIC, Australia',
      customer_credit_card_number: '1234-5678-1234-5678'
    }
  end
end
