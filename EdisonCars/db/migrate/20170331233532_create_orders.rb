class CreateOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :orders do |t|
      t.string :external_id
      t.string :name
      t.string :autonomy
      t.string :top_speed
      t.integer :batteries
      t.float :price
      t.date :order_date
      t.date :delivery_date
      t.string :customer_name
      t.string :customer_address
      t.string :customer_credit_card_number
    end
  end
end
