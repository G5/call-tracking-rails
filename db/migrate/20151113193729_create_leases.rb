class CreateLeases < ActiveRecord::Migration
  def change
    create_table :leases do |t|
      t.string :cid
      t.references :lead_source, index: true

      t.timestamps null: false
    end
    add_foreign_key :leases, :lead_sources
  end
end
