# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'json'
file_path = './task_1.json'

raw = File.read(file_path)
mails_json = JSON.parse(raw)
mails = []
mails_json.each do |mail|
  convo ={
    price_of_reservation: mail["price_of_reservation"].to_f,
    numbers_of_guests: mail["numbers_of_guests"].to_i,
    days_until_check_out: mail["days_until_check_out"].to_i,
    days_until_check_in: mail["days_until_check_in"].to_i,
    marker: mail["conversation_id"]
    }
  mails << convo
end

mails.each do |mail|
  conversations = Conversation.where(marker: mail[:marker])
  if conversations.empty?
    Conversation.create!(mail)
  end
end
