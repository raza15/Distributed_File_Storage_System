class CreateTwitters < ActiveRecord::Migration[5.0]
  def change
    create_table :twitters do |t|
      t.string :email
      t.string :twitteremail
      t.string :twitterpass

      t.timestamps
    end
  end
end
