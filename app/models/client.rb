class Client < ActiveRecord::Base
  #attr_accessible :name, :address
  belongs_to :user
  has_many :notes
  has_many :contacts, inverse_of: :client
  
  STATUSES = ['dnc', 'lead', 'open', 'client']
  TOPICS = ['Agriculture/Environment', 'Architecture', 'Arts & Culture', 'Business', 'Culinary', 'Education', 'Health/Medical', 'Outdoor', 'Travel']
  validates :address, uniqueness: { case_sensitive: false},
                      presence: true
  validates :status, inclusion: { :in => STATUSES,
                              message: "%{value} is not a valid type, please select either dnc, open or lead"}
  validates :category, inclusion: { :in => TOPICS,
                              message: "%{value} is not a valid Topic, please select from the list"}




  def self.search(w)
    where("name ILIKE ? OR address ILIKE ?", "%#{w}%", "%#{w}%")
  end

  def self.import(file)
    spreadsheet = open_spreadsheet(file)
    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      client = find_by_address(row["address"]) || new
      client.attributes = row.to_hash #.slice(*accessible_attributes)
      client.save!
    end
  end

  def self.open_spreadsheet(file)
    case File.extname(file.original_filename)
      when ".csv" then Csv.new(file.path, nil, :ignore)
      when ".xls" then Roo::Excel.new(file.path)
      when ".xlsx" then Roo::Excelx.new(file.path)
      else raise "Unknown file type: #{file.original_filename}"
      end
      end



end