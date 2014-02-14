class Follow < ActiveRecord::Base

  belongs_to :users, :class_name => "User", :foreign_key => "from"
  belongs_to :users, :class_name => "User", :foreign_key => "to"

  validates :from, :presence => true
  validates :to, :presence => true
end
