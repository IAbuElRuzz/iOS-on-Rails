class Department < ActiveRecord::Base
  has_many :employees
  
  validates :name, :presence => true
  
  def as_json(options = {})
    {:name => self.name, :employees => self.employees.as_json}
  end
end
