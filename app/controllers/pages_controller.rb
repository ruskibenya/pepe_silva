class PagesController < ApplicationController
  def home
    @messages = Message.all
    # @conversations = Conversation.all
    @test_message = Message.first
    @positive_messages = @messages.where(sentiment: "positive")
    @negative_messages = @messages.where(sentiment: "negative")
  end
end
