class AddMessageReceivedAtToConversations < ActiveRecord::Migration[5.2]
  def change
    add_column :conversations, :message_received_at, :string
  end
end
