class CreateShiurs < ActiveRecord::Migration
  def change
    create_table :shiurs do |t|
      t.integer :magid_id
      t.integer :category_id
      t.integer :subcat_id
      t.string :name
      t.string :description
      t.string :location_link
      t.date :shiur_date

      t.timestamps
    end
  end
end
