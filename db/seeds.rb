Location.delete_all

regions = 3.times.map do |i|
  Location.create!(
    location_type: :region,
    name: "Region #{i + 1}"
  )
end

# Для каждого региона создаем по 3 района
districts = regions.map do |region|
  3.times.map do |i|
    Location.create!(
      location_type: :district,
      parent_location: region,
      name: "#{region.name} District #{i + 1}"
    )
  end
end.flatten

# Для каждого района создаем по 3 города
cities = districts.map do |district|
  3.times.map do |i|
    Location.create!(
      location_type: :city,
      parent_location: district,
      name: "#{district.name} City #{i + 1}"
    )
  end
end.flatten

# Для каждого города создаем по 3 улицы
streets = cities.map do |city|
  3.times.map do |i|
    Location.create!(
      location_type: :street,
      parent_location: city,
      name: "#{city.name} Street #{i + 1}"
    )
  end
end.flatten

# Для каждой улицы создаем по 3 адреса
addresses = streets.map do |street|
  3.times.map do |i|
    Location.create!(
      location_type: :address,
      parent_location: street,
      name: "#{street.name} Address #{i + 1}"
    )
  end
end.flatten

p 'Created:'
p "Regions: #{regions.count}"
p "Districts: #{districts.count}"
p "Cities: #{cities.count}"
p "Streets: #{streets.count}"
p "Addresses: #{addresses.count}"
p "Total locations: #{Location.count}"

# Проверяем работу метода parent_locations для случайного адреса
sample_address = addresses.sample
parents = Location.parent_locations(sample_address)

p '--------------------------------'
p "Тестируем получение родителей для адреса #{sample_address.id}:"
p '--------------------------------'

parents.each do |loc|
  p "- #{loc.location_type}: #{loc.name} (id: #{loc.id})"
end

p '--------------------------------'
p 'Тестируем сортировку:'

# Возьмем несколько локаций разных типов
test_locations = [
  addresses.sample,                 # случайный адрес
  addresses.sample,                 # другой адрес того же уровня
  streets.sample,                   # случайная улица
  cities.sample,                    # случайный город
  regions.sample,                   # случайный регион
  addresses.sample.parent_location  # родитель случайного адреса (улица)
]

p '--------------------------------'
p 'До сортировки:'

test_locations.each do |loc|
  p "- #{loc.location_type}: #{loc.name} (id: #{loc.id})"
end

sorted_locations = Location.sort_locations(test_locations)

p '--------------------------------'
p 'После сортировки:'

sorted_locations.each do |loc|
  p "- #{loc.location_type}: #{loc.name} (id: #{loc.id})"
end
