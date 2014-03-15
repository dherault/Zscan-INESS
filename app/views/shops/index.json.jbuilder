json.array!(@shops) do |shop|
  json.extract! shop, :name, :description, :level, :password_digest
  json.url shop_url(shop, format: :json)
end
