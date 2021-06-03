class CreateRelationships < ActiveRecord::Migration[6.1]
  def change
    create_table :relationships, id: :string do |t|
      t.references :user, type: :string, null: false, foreign_key: true
      t.references :follow, type: :string, null: false, foreign_key: { to_table: :users }

      t.timestamps
      t.index [:user_id, :follow_id], unique: true
    end
  end
end
