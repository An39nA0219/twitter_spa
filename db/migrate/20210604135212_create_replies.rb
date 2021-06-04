class CreateReplies < ActiveRecord::Migration[6.1]
  def change
    create_table :replies, id: :string do |t|
      t.references :tweet, type: :string, null: false, foreign_key: true
      t.references :reply, type: :string, null: false, foreign_key: { to_table: :tweets }
      
      t.timestamps
    end
  end
end
