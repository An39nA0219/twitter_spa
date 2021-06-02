class CreateTweets < ActiveRecord::Migration[6.1]
  def change
    create_table :tweets, id: :string do |t|
      t.references :user, type: :string, null: false, foreign_key: true
      t.text :content

      t.timestamps
    end
  end
end
