class AddAttributesToLeads < ActiveRecord::Migration
  def change
    add_column :leads, :caller_zip, :string
    add_column :leads, :caller_name, :string
    add_column :leads, :call_status, :string
    add_column :leads, :call_duration, :integer
  end
end
