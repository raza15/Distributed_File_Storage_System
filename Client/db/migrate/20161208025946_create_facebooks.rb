class CreateFacebooks < ActiveRecord::Migration[5.0]
  def change
    create_table :facebooks do |t|
      t.string :email
      t.string :fbemail
      t.string :fbpass

      t.timestamps
    end
  end
end
