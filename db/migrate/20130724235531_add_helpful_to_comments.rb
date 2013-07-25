class AddHelpfulToComments < ActiveRecord::Migration
  def change
    add_column :comments, :helpful, :boolean
  end
end
