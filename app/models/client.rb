class Client < ActiveRecord::Base
  validates :address, presence: true,
                      uniqueness: true
  
  def self.search(q)
    where("name LIKE ?", "%#{q}%")
    where("address LIKE ?", "%#{q}%")
  end
  
end
