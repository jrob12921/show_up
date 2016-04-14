class Event < ActiveRecord::Base
  belongs_to :user
  has_one :group_message

  def user_attending?(user)
    Event.where(jb_event_id: self.jb_event_id, user_id: user.id).present? ? true : false
  end
end
