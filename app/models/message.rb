class Message < ApplicationRecord
  belongs_to :conversation
  include Comparable

  def <=>(other)
    c1 = Conversation.where(id:self.conversation_id)[0]
    c2 = Conversation.where(id:other.conversation_id)[0]
    if c1.days_until_check_in<=0 && c1.days_until_check_out>0
      if c2.days_until_check_in<=0 && c2.days_until_check_out>0
        return -c1.days_until_check_in <=> -c2.days_until_check_in
      else
        return 1
      end
    elsif c1.days_until_check_in>0 && c1.days_until_check_out<=0
      if c2.days_until_check_in<0 && c2.days_until_check_out>0
        return -1
      elsif c2.days_until_check_in<=0 && c2.days_until_check_out<=0
        return 1
      else
        return c1.days_until_check_in <=> c2.days_until_check_in
      end
    elsif c1.days_until_check_in<=0 && c1.days_until_check_out<=0
      if c2.days_until_check_in<=0 && c2.days_until_check_out<=0
        return -c1.days_until_check_out <=> -c2.days_until_check_out
      else
        return -1
      end
    end
  end
  def is_checked_in?
    c1 = Conversation.where(id:self.conversation_id)[0]
    return c1.days_until_check_in<=0 && c1.days_until_check_out>0
  end
  def is_checked_out?
    c1 = Conversation.where(id:self.conversation_id)[0]
    return c1.days_until_check_in<=0 && c1.days_until_check_out<=0
  end
  def is_pre_checked?
    c1 = Conversation.where(id:self.conversation_id)[0]
    return c1.days_until_check_in>0 && c1.days_until_check_out>0
  end

  SENTIMENTS_ORDERED = ['negative', 'neutral', 'positive']

  # Returns a case statement for ordering by a particular set of strings
  # Note that the SQL is built by hand and therefore injection is possible,
  # however since we're declaring the priorities in a constant above it's
  # safe.
  def sentiment_to_int
    if self.sentiment == 'negative'
      return 0
    elsif self.sentiment == 'neutral'
      return 1
    else
      return 2
    end
  end
  def count_tags
    Tagging.where(message_id:self.id).count
  end

  def get_price
    converation = Conversation.where(id:self.conversation_id)[0]
    converation.price_of_reservation
  end

  def self.get_all_sorted
    Message.all.sort{|a,b| [a,a.sentiment_to_int,a.count_tags,a.get_price]<=>[b,b.sentiment_to_int,b.count_tags,b.get_price]}
  end


  def self.get_negatives
    Message.where(sentiment:"negative")
  end
  def self.get_positives
    Message.where(sentiment:"positive")
  end
  def self.get_neutrals
    Message.where(sentiment:"neutral")
  end

  def self.order_by_case
    ret = "CASE"
    SENTIMENTS_ORDERED.each_with_index do |p, i|
      ret << " WHEN sentiment = '#{p}' THEN #{i}"
    end
    ret << " END"
  end

  scope :by_sentiment, -> {order (order_by_case)}


end
