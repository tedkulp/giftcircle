class UserCircle < ActiveRecord::Base
  belongs_to :user, :class_name => "User", :foreign_key => "user_id"
  belongs_to :circle, :class_name => "Circle", :foreign_key => "circle_id"
end
