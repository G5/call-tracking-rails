class AddPropertiesToLeads < ActiveRecord::Migration
  def change
    add_column :leads, :properties, :json, default: {}, null: false
  end
end
