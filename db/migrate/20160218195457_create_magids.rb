class CreateMagids < ActiveRecord::Migration
  def change
    create_table :magids do |t|
      t.string :name

      t.timestamps
    end
  end
end
