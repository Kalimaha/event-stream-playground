class CreateOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :orders do |t|
      t.string :external_id
      t.string :name
      t.float :price
      t.date :order_date
      t.date :delivery_date
      t.string :customer_name
    end
  end
end
