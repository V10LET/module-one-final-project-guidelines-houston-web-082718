class CreateSnowman < ActiveRecord::Migration[5.0]
  def change
    create_table :snowmen do |t|
      t.string :name
    end
  end
end
