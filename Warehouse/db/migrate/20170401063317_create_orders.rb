class CreateOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :orders do |t|
      t.string :external_id
      t.string :name
      t.integer :batteries
      t.date :order_date
      t.date :delivery_date
    end
  end
end
