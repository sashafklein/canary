class CreateRules < ActiveRecord::Migration
  def change
    create_table :rules do |t|
      t.integer :user_id, unique: true, index: true
      t.string :term
      t.string :twitter_user_id
      t.string :twitter_user_image
      t.string :twitter_user_name

      t.timestamps null: false
    end
  end
end
