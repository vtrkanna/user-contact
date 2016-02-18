class AddColumnToApiKeys < ActiveRecord::Migration
  def change
    add_reference :api_keys, :user, index: true, foreign_key: true
  end
end
