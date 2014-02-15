class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :name, :uniqueness => { case_sensitive: false }, :presence => true

  has_many :follows_from, :foreign_key => "from", :class_name => "Follow"
  has_many :follows_to, :foreign_key => "to", :class_name => "Follow"
  has_many :followed, :through => :follows_from, :source => "to"
  has_many :followers, :through => :follows_to, :source => "from"
end
