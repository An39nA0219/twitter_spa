class Reply < ApplicationRecord
  belongs_to :tweet
  belongs_to :reply, class_name: 'Tweet', optional: true
end
