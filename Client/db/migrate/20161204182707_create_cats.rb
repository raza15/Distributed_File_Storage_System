class CreateCats < ActiveRecord::Migration[5.0]
  def change
    create_table :cats do |t|
      t.string :email
      t.string :filename
      t.string :cat

      t.timestamps
    end
  end
end
