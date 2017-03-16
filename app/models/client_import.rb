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
      if client.persisted?
        if client.status == "dnc" || client.status == "lead"
          client
          taken = true
        else
          client.user_id = row["user_id"]
          client.status = row["status"]
          client.name = row["name"]
          client.address = row["address"]
          client.category = row["category"]
          client.main_phone = row["company_phone"]
        end
      else
        client.user_id = row["user_id"]
        client.status = row["status"]
        client.name = row["name"]
        client.address = row["address"]
        client.category = row["category"]
        client.main_phone = row["company_phone"]
        if client.new_record?
          client.save!
        end
      end
      #client.attributes = row.to_hash #.slice(Client.client_import_params)
      if taken != true
        contact_one = Contact.new
        contact_one.title = row["contact_title"]
        contact_one.first_name = row["contact_first_name"]
        contact_one.last_name = row["contact_last_name"]
        contact_one.phone_number = row["contact_phone_number"]
        contact_one.phone_ext = row["contact_ext"]
        contact_one.cell_number = row["contact_cell"]
        contact_one.email = row["contact_email"]
        contact_one.client_id = client.id
        contact_one.save! unless contact_one.nil?
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