class Tweet < ApplicationRecord
  belongs_to :user

  has_many :favorite_logs
  has_many :favor_users, through: :favorite_logs, source: :user

end
