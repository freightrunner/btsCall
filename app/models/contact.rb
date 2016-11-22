class Contact < ActiveRecord::Base
  belongs_to :client
  
  def self.search(q)
    where("@client.id LIKE ?", "%#{client_id}%")
    where("user_id LIKE ?", "%#{user_id}%")
  end
end
