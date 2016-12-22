class CreateUploadFileToServers < ActiveRecord::Migration[5.0]
  def change
    create_table :upload_file_to_servers do |t|
      t.string :email
      t.string :filename

      t.timestamps
    end
  end
end
