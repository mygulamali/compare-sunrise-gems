require 'solareventcalculator'
require_relative 'my_data'

class SolarEventCalculatorData < MyData
  def calculate
    @times = []

    (Date.new(year, 1, 1)..Date.new(year, 12, 31)).each do |date|
      calculator = SolarEventCalculator.new(date, lat, lng)
      @times << {
        rise: calculator.compute_utc_official_sunrise,
        set: calculator.compute_utc_official_sunset
      }
    end

    @times
  end
end
