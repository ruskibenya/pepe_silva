require 'json'
require_relative './app/models/conversation'
file_path = '../task_1.json'

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
  marker = mail.delete(:marker)
  @conversation = Conversation.new(mail)
  @conversation.id = marker
  @conversation.save!
end
