class CreateProfileConnections < ActiveRecord::Migration
  def change
    create_table :profile_connections do |t|
      t.references :following, index: true
      t.references :followed, index: true

      t.timestamps
    end
  end
end
