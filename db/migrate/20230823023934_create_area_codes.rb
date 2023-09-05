class CreateAreaCodes < ActiveRecord::Migration[7.0]
  def change
    create_table :area_codes do |t|
      t.string :sa_code

      t.timestamps
    end
    add_index :area_codes, :sa_code, unique: true
  end
end
