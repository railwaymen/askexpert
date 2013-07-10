class CreateAuthentications < ActiveRecord::Migration
  def change
    create_table :authentications do |t|
      t.references :user, index: true
      t.string :provider
      t.string :uid
      t.text :token
      t.string :secret

      t.timestamps
    end
    add_index :authentications, :uid
  end
end
