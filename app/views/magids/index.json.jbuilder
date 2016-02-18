json.array!(@magids) do |magid|
  json.extract! magid, :id, :name
  json.url magid_url(magid, format: :json)
end
