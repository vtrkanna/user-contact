class AddColumnToUsers < ActiveRecord::Migration
  def change
    add_column :users, :email_varify, :boolean
  end
end
