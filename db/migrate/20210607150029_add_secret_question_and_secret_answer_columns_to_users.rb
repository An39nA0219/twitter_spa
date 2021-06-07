class AddSecretQuestionAndSecretAnswerColumnsToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :secret_question, :string
    add_column :users, :secret_answer, :string
  end
end
