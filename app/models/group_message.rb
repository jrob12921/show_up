class GroupMessage < ActiveRecord::Base
  belongs_to :event
  belongs_to :user

  validates :body, presence: true, allow_blank: false
end
