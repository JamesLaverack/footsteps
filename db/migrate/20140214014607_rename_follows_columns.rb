class RenameFollowsColumns < ActiveRecord::Migration
  def change
    rename_column :follows, :from_id, :from
    rename_column :follows, :to_id, :to
  end
end
