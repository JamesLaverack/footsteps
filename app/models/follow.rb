class Follow < ActiveRecord::Base

  belongs_to :from, :class_name => "User"
  belongs_to :to, :class_name => "User"

  validates :from, :presence => true
  validates :to, :presence => true
  
  validates :from, :uniqueness => { :scope => :to }, :allow_nil => true
end
