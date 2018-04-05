class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :nameid
      t.string :first_name
      t.string :last_name
      t.string :tel

      t.timestamps
    end
  end
end
