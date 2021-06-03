class User < ApplicationRecord
  has_secure_password

  has_many :tweets

  has_many :relationships
  has_many :followings, through: :relationships, source: :follow
  has_many :reverses_of_relationship, class_name: 'Relationship', foreign_key: 'follow_id'
  has_many :followers, through: :reverses_of_relationship, source: :user

  has_many :favorite_logs
  has_many :favorite_tweets, through: :favorite_logs, source: :tweet
end
