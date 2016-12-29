json.array!(@clients) do |client|
    json.name       client.name
    json.address    client.address
end