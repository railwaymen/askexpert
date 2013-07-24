class CreateShares < ActiveRecord::Migration
  def change
    create_table :shares do |t|
      t.references :sender, index: true
      t.references :recipient, index: true
      t.references :post, index: true
      t.text :content

      t.timestamps
    end
  end
end
