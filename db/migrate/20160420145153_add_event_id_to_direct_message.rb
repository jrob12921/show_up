class AddEventIdToDirectMessage < ActiveRecord::Migration
  def change
    add_reference :direct_messages, :event, index: true, foreign_key: true
  end
end
