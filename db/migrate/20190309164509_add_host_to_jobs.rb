class AddHostToJobs < ActiveRecord::Migration[5.2]
  def change
    add_column :jobs,:host,:string
  end
end
