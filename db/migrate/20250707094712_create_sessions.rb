class CreateSessions < ActiveRecord::Migration[8.0]
  def change
    create_table :sessions do |t|
      t.references :user, null: false, foreign_key: true
      t.string :session_type
      t.datetime :start_time
      t.datetime :end_time
      t.integer :focus_level

      t.timestamps
    end
  end
end
