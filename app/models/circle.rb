class Circle < ActiveRecord::Base
  
  #will paginate
  cattr_reader :per_page
  @@per_page = 10
  
  has_many :user_circles, :class_name => "UserCircle", :foreign_key => "circle_id"
  has_many :users, :through => :user_circles
  
  belongs_to :admin_user, :class_name => "User", :foreign_key => "admin_user_id"
  belongs_to :created_by, :class_name => "User", :foreign_key => "created_by"
  
end
