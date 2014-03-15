json.array!(@stocks) do |stock|
  json.extract! stock, :qty, :shop_id, :product_id
  json.url stock_url(stock, format: :json)
end
