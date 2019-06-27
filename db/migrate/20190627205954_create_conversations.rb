class CreateConversations < ActiveRecord::Migration[5.2]
  def change
    create_table :conversations do |t|
      t.float :price_of_reservation
      t.integer :numbers_of_guests
      t.integer :days_until_check_out
      t.integer :days_until_check_in

      t.timestamps
    end
  end
end
