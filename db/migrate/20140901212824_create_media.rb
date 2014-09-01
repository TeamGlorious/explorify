class CreateMedia < ActiveRecord::Migration
  def change
    create_table :media do |t|
      t.string :full_res_img
      t.string :thumnail
      t.string :location
      t.string :date_taken

      t.timestamps
    end
  end
end
