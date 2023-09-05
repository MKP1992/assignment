class CreateExcavators < ActiveRecord::Migration[7.0]
  def change
    create_table :excavators do |t|
      t.string :company_name
      t.string :address
      t.boolean :crew_onsite, default: false
      t.references :ticket, null: false, foreign_key: true

      t.timestamps
    end
  end
end