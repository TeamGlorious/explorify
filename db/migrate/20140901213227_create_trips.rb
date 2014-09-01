class CreateTrips < ActiveRecord::Migration
  def change
    create_table :trips do |t|
      t.references :user
      t.string :date_start
      t.string :date_end
      t.string :title
      t.string :description

      t.timestamps
    end
  end
end
