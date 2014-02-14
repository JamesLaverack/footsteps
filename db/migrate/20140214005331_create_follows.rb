class CreateFollows < ActiveRecord::Migration
  def change
    create_table :follows do |t|
      t.references :from
      t.references :to

      t.timestamps
    end
  end
end
