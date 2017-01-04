json.array! @clients, partial: 'clients/client', as: :client

json.array!(@clients) do |client|
    json.name       client.name
    json.address    client.address
end