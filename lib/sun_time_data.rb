require 'sun_time'
require_relative 'my_data'

class SunTimeData < MyData
  def calculate
    @times = []

    (Date.new(year, 1, 1)..Date.new(year, 12, 31)).each do |date|
      calculator = SunTime.new(date, lat, lng)
      @times << {
        rise: calculator.sunrise,
        set: calculator.sunset
      }
    end

    @times
  end
end
