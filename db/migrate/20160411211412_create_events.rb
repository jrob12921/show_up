class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.references :user, index: true, foreign_key: true
      t.integer :jb_event_id

      t.timestamps null: false
    end
  end
end
