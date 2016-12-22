class CreateGmails < ActiveRecord::Migration[5.0]
  def change
    create_table :gmails do |t|
      t.string :email
      t.string :gmailemail
      t.string :gmailpass

      t.timestamps
    end
  end
end
