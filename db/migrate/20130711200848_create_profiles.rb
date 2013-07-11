class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.references :user, index: true
      t.references :authentication, index: true
      t.string :provider
      t.string :uid
      t.string :name
      t.text :summary
      t.string :location

      t.timestamps
    end
    add_index :profiles, :uid
  end
end
