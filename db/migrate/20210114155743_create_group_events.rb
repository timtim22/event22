class CreateGroupEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :group_events do |t|
      t.string :name
      t.text :description
      t.string :location
      t.datetime :start_date
      t.datetime :end_date
      t.integer :duration
      t.integer :status, default: 'draft'
      t.boolean :is_deleted, default: false

      t.timestamps
    end
  end
end
