class AddListingsTable < ActiveRecord::Migration[5.1]
  def change

    create_table :listings do |t|
      t.integer :rmls_number
      t.text :description
      t.string :nhoodbldg
      t.decimal :taxyr
      t.integer :yrbuilt
      t.string :elem
      t.decimal :baths
      t.integer :beds
      t.integer :sqft
      t.integer :price
      t.string :status
      t.string :county
      t.string :address

      t.timestamps
    end

    add_index :listings, :rmls_number, unique: true
    add_index :listings, :price
    add_index :listings, :sqft
    add_index :listings, :yrbuilt
    add_index :listings, :status
  end
end
