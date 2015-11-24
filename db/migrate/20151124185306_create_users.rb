 class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :twitter_key
      t.string :twitter_secret
      t.string :email
      t.string :username
      t.string :twitter_id
      t.string :image

      t.timestamps null: false
    end
  end
end
