# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'json'
require 'csv'
require 'sentimental'

file_path = './task_1.json'

raw = File.read(file_path)
mails_json = JSON.parse(raw)
mails = []
mails_json.each do |mail|
  convo ={
    price_of_reservation: mail["price_of_reservation"].to_f,
    numbers_of_guests: mail["numbers_of_guests"].to_i,
    days_until_check_out: mail["days_until_check_in"].to_i,
    days_until_check_in: mail["days_until_check_out"].to_i,
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

#file_path = './task_1.json'

analyzer = Sentimental.new
analyzer.load_defaults
analyzer.threshold = 0.2

#raw = File.read(file_path)
#mails_json = JSON.parse(raw)

mails_json.each do |mail|
  conversation = Conversation.where(marker: mail["conversation_id"])
  if !conversation.empty?
    conversation = conversation[0]
    sentiment = analyzer.sentiment mail["message"].to_s
    @message = Message.new(message: mail["message"],sentiment: sentiment)
    @message.conversation_id= conversation.id
    #p @message
    @message.save!
  end
end


CSV.foreach('tags.csv') do |row|
  Tag.create!(tag:row[0])
end
