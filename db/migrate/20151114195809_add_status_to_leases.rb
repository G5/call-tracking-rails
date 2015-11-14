class AddStatusToLeases < ActiveRecord::Migration
  def change
    add_column :leases, :status, :string, null: false, :default => "active"

  end
end
