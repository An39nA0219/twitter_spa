class Tweet < ApplicationRecord
  belongs_to :user

  has_many :favorite_logs
  has_many :favor_users, through: :favorite_logs, source: :user

  has_many :replies
  has_many :reply_tweets, through: :replies, source: :reply
  has_many :reverses_of_replies, class_name: 'Replies', foreign_key: 'reply_id'
  has_many :original_tweets, through: :reverses_of_replies, source: :tweet

end
