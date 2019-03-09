class AddClientsToJobs < ActiveRecord::Migration[5.2]
  def change
    add_column :jobs, :clients, :string
  end
end
