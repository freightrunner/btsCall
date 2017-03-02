class ClientImport
  # switch to ActiveModel::Model in Rails 4
  extend ActiveModel::Model
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attr_accessor :file



  def initialize(attributes = {})
    attributes.each { |name, value| send("#{name}=", value) }
  end

  def persisted?
    false
  end

  def save
    if imported_clients.map(&:valid?).all?
      imported_clients.each(&:save!)
      true
    else
      imported_clients.each_with_index do |client, index|
        client.errors.full_messages.each do |message|
          errors.add :base, "Company: #{client.name} on Row #{index+2}: #{message}"
        end
      end
      false
    end
  end

  def imported_clients
    @imported_clients ||= load_imported_clients
  end

  def load_imported_clients
    spreadsheet = open_spreadsheet
    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).map do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      client = Client.find_by_address(row["address"]) || Client.new
      #client.attributes = row.to_hash #.slice(Client.client_import_params)
      clientObj = client.id
      client.user_id = row["user_id"]
      client.status = row["status"]
      client.name = row["name"]
      client.address = row["address"]
      client.category = row["category"]
      client.main_phone = row["company_phone"]
      contactTitle = row["contact_title"]
      contact = Contact.where(:title=>contactTitle).first
      contact_id = contact.id unless contact.nil?
      if contact.nil?
        contactObj = Contact.new
        contactObj.title = contactTitle
        contactObj.first_name = row["contact_first_name"]
        contactObj.last_name = row["contact_last_name"]
        contactObj.phone_number = row["contact_phone_number"]
        contactObj.phone_ext = row["contact_ext"]
        contactObj.cell_number = row["contact_cell"]
        contactObj.email = row["contact_email"]
        contactObj.client_id = contactObj.id
        contactObj.save!
      end
      client
    end
  end

  def open_spreadsheet
    case File.extname(file.original_filename)
    when ".csv" then Csv.new(file.path, nil, :ignore)
    when ".xls" then Roo::Excel.new(file.path)
    when ".xlsx" then Roo::Excelx.new(file.path)
    else raise "Unknown file type: #{file.original_filename}"
    end
  end
end