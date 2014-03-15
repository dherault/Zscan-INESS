json.array!(@users) do |user|
  json.extract! user, :amount
  json.url user_url(user, format: :json)
end
