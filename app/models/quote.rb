class Quote < ActiveRecord::Base
  attr_accessible :numero, :quota, :servizio

  belongs_to :project
end
