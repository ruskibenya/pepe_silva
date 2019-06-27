class AddMarkerToConversations < ActiveRecord::Migration[5.2]
  def change
    add_column :conversations, :marker, :string, unique: true
  end
end
