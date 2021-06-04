class Reply < ApplicationRecord
  belongs_to :tweet
  belongs_to :reply, optional: true
end
