json.array!(@cards) do |card|
  json.extract! card, :scannable_id, :scannable_type, :uid
  json.url card_url(card, format: :json)
end
