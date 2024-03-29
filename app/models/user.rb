class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :first_name, :last_name, :email, :password, :password_confirmation, :remember_me, :secret_code
  validates_presence_of :first_name, :last_name
  validates :secret_code, :presence => true, :format => { :with => /^letmeinplease$/ }
  
  has_many :user_circles, :class_name => "UserCircle", :foreign_key => "user_id", :dependent => :destroy
  has_many :circles, :through => :user_circles
  
  has_many :gifts, :dependent => :destroy
  accepts_nested_attributes_for :gifts, :reject_if => lambda { |a| a[:name].blank? }, :allow_destroy => true
  
  has_many :bought_gifts, :class_name => "Gift", :foreign_key => "bought_by_id"
  
  #Hack for now
  after_create :add_user_to_default_list
  
  def add_user_to_default_list
    @circle = Circle.find(:first)
    if @circle
      user_circle = UserCircle.new
      user_circle.circle_id = @circle.id
      user_circle.user_id = self.id
      user_circle.save
    end
  end
  
  def full_name
    str = ''
    unless self.first_name.blank?
      str = str + self.first_name
    end
    unless self.last_name.blank?
      str = str + ' ' + self.last_name
    end
    if str == ''
      str = self.email
    end
    str
  end
  
end
