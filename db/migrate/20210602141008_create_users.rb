class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users, id: :string do |t|
      t.string :name
      t.string :email
      t.string :password_digest
      t.text :profile

      t.timestamps
    end
  end
end
