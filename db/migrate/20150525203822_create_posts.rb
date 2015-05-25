class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.integer :user_id
      t.text :content
      t.text :content_html

      t.timestamps null: false
    end

    add_index         :posts, :user_id
    add_foreign_key   :posts, :users, dependent: :delete
  end
end