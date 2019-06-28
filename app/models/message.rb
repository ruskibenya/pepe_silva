class Message < ApplicationRecord
  belongs_to :conversation
  SENTIMENTS_ORDERED = ['negative', 'neutral', 'positive']

  # Returns a case statement for ordering by a particular set of strings
  # Note that the SQL is built by hand and therefore injection is possible,
  # however since we're declaring the priorities in a constant above it's
  # safe.
  def count_tags
    Tagging.where(message_id:self.id).count
  end

  def self.sort_by_tags(msgs)
    msgs.sort_by{ |msg|
      msg.count_tags
    }.reverse
  end


  def self.order_by_case
    ret = "CASE"
    SENTIMENTS_ORDERED.each_with_index do |p, i|
      ret << " WHEN sentiment = '#{p}' THEN #{i}"
    end
    ret << " END"
  end

  scope :by_sentiment, -> {order (order_by_case)}
  scope :by_tags, -> { order(count_tags :desc) }

end
