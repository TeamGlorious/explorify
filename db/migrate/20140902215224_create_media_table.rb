class CreateMediaTable < ActiveRecord::Migration
  def change
    create_table :media do |t|
      t.references :trip
      t.string :full_res_img
      t.string :med_res_img
      t.string :thumbnail
      t.float :lat
      t.float :long
      t.string :date_taken

      t.timestamps
    end
  end
end
