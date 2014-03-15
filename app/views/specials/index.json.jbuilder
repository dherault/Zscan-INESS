json.array!(@specials) do |special|
  json.extract! special, :name, :description, :function
  json.url special_url(special, format: :json)
end
