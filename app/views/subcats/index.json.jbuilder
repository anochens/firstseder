json.array!(@subcats) do |subcat|
  json.extract! subcat, :id, :name, :category_id
  json.url subcat_url(subcat, format: :json)
end
