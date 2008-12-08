class <%= migration_name %> < ActiveRecord::Migration
  def self.up
    create_table :<%= table_name %> do |t|
      t.string :title
      t.integer :created_by
      t.timestamps
    end
    create_table :memberships do |t|
      t.integer :user_id, :null => false
      t.integer :group_id, :null => false
      t.datetime :accepted_at
      t.boolean :admin_role, :default => false
      t.timestamps
    end
  end

  def self.down
    drop_table :<%= table_name %>
    drop_table :memberships
  end
end
