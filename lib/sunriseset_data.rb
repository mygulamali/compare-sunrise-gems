require 'sunriseset'
require_relative 'my_data'

class SunRiseSetData < MyData
  def calculate
    @times = []

    (Date.new(year, 1, 1)..Date.new(year, 12, 31)).each do |date|
      calculator = SunRiseSet.new(date.to_datetime, lat, lng)
      @times << {
        rise: calculator.sunrise,
        set: calculator.sunset
      }
    end

    @times
  end
end
