class AddPriceHistory < ActiveRecord::Migration[5.1]
  def change
    create_table :price_histories do |t|
      t.integer :rmls_number
      t.integer :old_price
      t.integer :new_price

      t.timestamps
    end

  end
end
