class Retweet < ApplicationRecord
  belongs_to :tweet

  def to_s
    username
  end
end
