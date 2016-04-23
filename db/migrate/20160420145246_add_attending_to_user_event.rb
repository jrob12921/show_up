class AddAttendingToUserEvent < ActiveRecord::Migration
  def change
    add_column :user_events, :attending, :boolean
  end
end
