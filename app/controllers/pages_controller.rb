class PagesController < ApplicationController
  def home
    @messages = Message.get_all_sorted
    # @conversations = Conversation.all
    @test_message = Message.first
    # raise
    @positive_messages = Message.get_positives
    @negative_messages = Message.get_negatives

  end

  def show_positives
    @messages = Message.get_positives
    @positive_messages = Message.get_positives
    @negative_messages = Message.get_negatives
  end

  def show_negatives
    @messages = Message.get_negatives
    @positive_messages = Message.get_positives
    @negative_messages = Message.get_negatives
  end
end
