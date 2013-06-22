class Backer < ActiveRecord::Base
  attr_accessible :contribution_id, :user_id

  validates :contribution_id, :user_id, presence: true

end
