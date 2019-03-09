class CreateJobs < ActiveRecord::Migration[5.2]
  def change
    create_table :jobs do |t|
      t.integer :server_id
      t.decimal :server_load_alarm
      t.string :user
      t.boolean :verbose
      t.string :test_mode
      t.string :debug_mode
      t.string :log_file_path
      t.boolean :send_notifications
      t.timestamps
    end
  end
end
