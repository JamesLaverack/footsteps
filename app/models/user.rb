class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :name, :uniqueness => { case_sensitive: false }, :presence => true

  has_many :follows, :foreign_key => "from"
  has_many :follows, :foreign_key => "to"
  has_many :followed, :through => :follows, :source => "from"
  has_many :followers, :through => :follows, :source => "to"
end
