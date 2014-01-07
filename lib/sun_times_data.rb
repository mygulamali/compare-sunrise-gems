require 'sun_times'
require_relative 'my_data'

class SunTimesData < MyData
  def calculate
    @times = []

    (Date.new(year, 1, 1)..Date.new(year, 12, 31)).each do |date|
      @times << {
        rise: SunTimes.new.rise(date, lat, lng),
        set: SunTimes.new.set(date, lat, lng)
      }
    end

    @times
  end
end
