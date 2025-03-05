class Location < ActiveRecord::Base
  belongs_to :parent_location, class_name: "Location", foreign_key: "location_id", optional: true

  LOCATION_TYPES = {
    region: 0,
    district: 1,
    city: 2,
    street: 3,
    address: 4
  }

  enum :location_type, LOCATION_TYPES

  # Метод который на вход принимает экземпляр класса Location и возвращает на выходе массив экземпляров класса Location.
  # Содержащий рекурсивно всех родителей location, включая сам location.
  #
  # @param location [Location] instance of class Location
  # @return [Array<Location>] array of locations starting from root parent to the given location
  def self.parent_locations(location)
    result = []
    current_location = location

    while current_location
      result.unshift(current_location)
      current_location = current_location.parent_location
    end

    result
  end

  # Метод сортировки массива экземляров класса Location.
  # 1. Родитель выводится раньше потомка.
  # 2. Несвязанные location сортируются по порядку в LOCATION_TYPES.
  # 3. Location одного типа сортируются по глубине вложенности.
  #
  # @param locations [Array<Location>] array of locations to sort
  # @return [Array<Location>] sorted array of locations
  def self.sort_locations(locations)
    locations.sort do |a, b|
      # Проверяем связь родитель-потомок
      a_parents = parent_locations(a)
      b_parents = parent_locations(b)

      if a_parents.include?(b)
        -1
      elsif b_parents.include?(a)
        1
      else
        # Если нет связи родитель-потомок, сравниваем по типу
        type_comparison = LOCATION_TYPES[a.location_type.to_sym] <=> LOCATION_TYPES[b.location_type.to_sym]

        if type_comparison != 0
          type_comparison
        else
          # Если типы одинаковые, сравниваем по глубине вложенности
          a_parents.length <=> b_parents.length
        end
      end
    end
  end
end
