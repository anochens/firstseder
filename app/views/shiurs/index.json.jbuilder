json.array!(@shiurs) do |shiur|
  json.extract! shiur, :id, :magid_id, :category_id, :subcat_id, :name, :description, :location_link, :shiur_date
  json.url shiur_url(shiur, format: :json)
end
