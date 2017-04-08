class Note < ActiveRecord::Base
  belongs_to :client, inverse_of: :notes
  #scope :by_client => client_id { where(:client_id => client_id) }

  def self.search(q)
    where("@client.id LIKE ?", "%#{client_id}%")
    where("user_id LIKE ?", "%#{user_id}%")
  end
end
