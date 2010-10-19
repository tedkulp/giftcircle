class Gift < ActiveRecord::Base
  
  cattr_reader :per_page
  @@per_page = 10
  
  belongs_to :user
  
  URL_FORMAT = URI::regexp(%w(http https))
  validates_format_of :url, :with => URL_FORMAT, :allow_blank => true
  
end
