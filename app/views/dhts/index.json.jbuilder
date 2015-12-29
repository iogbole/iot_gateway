json.array!(@dhts) do |dht|
  json.extract! dht, :id, :chipid, :location, :description, :temperature, :humidity
  json.url dht_url(dht, format: :json)
end
