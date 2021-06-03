class CreateFavoriteLogs < ActiveRecord::Migration[6.1]
  def change
    create_table :favorite_logs, id: :string do |t|
      t.references :user, type: :string, null: false, foreign_key: true
      t.references :tweet, type: :string, null: false, foreign_key: true

      t.timestamps
      t.index [:user_id, :tweet_id], unique: true
    end
  end
end
