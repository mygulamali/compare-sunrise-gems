require 'csv'
require_relative 'solareventcalculator_data'
require_relative 'sun_time_data'
require_relative 'sun_times_data'
require_relative 'sunriseset_data'
require_relative 'usno_data'

class DataComparator
  attr_reader :data, :errors, :lat, :lng, :year

  def initialize(usno_data_filename)
    usno_data = USNO_Data.new(usno_data_filename)
    @year = usno_data.year
    @lat = usno_data.lat
    @lng = usno_data.lng
    
    @data = {}
    @data[:usno] = usno_data.calculate

    @errors = {}
  end

  def calculate_data
    @data[:solareventcalculator] = SolarEventCalculatorData.new(year, lat, lng).calculate
    @data[:sun_time] = SunTimeData.new(year, lat, lng).calculate
    @data[:sun_times] = SunTimesData.new(year, lat, lng).calculate
    @data[:sunriseset] = SunRiseSetData.new(year, lat, lng).calculate
  end

  def calculate_errors
    @errors[:solareventcalculator] = calculate_errors_between(:usno, :solareventcalculator)
    @errors[:sun_time] = calculate_errors_between(:usno, :sun_time)
    @errors[:sun_times] = calculate_errors_between(:usno, :sun_times)
    @errors[:sunriseset] = calculate_errors_between(:usno, :sunriseset)
  end

  def output_errors(csv_filename)
    CSV.open(csv_filename, 'w') do |csv|
      csv << [
        "Day of year #{year}",
        "solareventcalculator rise [min]",
        "solareventcalculator set [min]",
        "sun_time rise [min]",
        "sun_time set [min]",
        "sun_times rise [min]",
        "sun_times set [min]",
        "sunriseset rise [min]",
        "sunriseset set [min]",
      ]

      data[:usno].each_index do |i|
        csv << [
          data[:usno][i][:rise].yday,
          errors[:solareventcalculator][i][:rise],
          errors[:solareventcalculator][i][:set],
          errors[:sun_time][i][:rise],
          errors[:sun_time][i][:set],
          errors[:sun_times][i][:rise],
          errors[:sun_times][i][:set],
          errors[:sunriseset][i][:rise],
          errors[:sunriseset][i][:set],
        ]
      end
    end
  end

  private

  def calculate(expected_data_key, observed_data_key)
    data_errors = []

    loop do
      expected_data = data[expected_data_key].next rescue :eof
      observed_data = data[observed_data_key].next rescue :eof
      return data_errors if expected_data == :eof
      data_errors << {
        rise: error(expected_data[:rise], observed_data[:rise]),
        set: error(expected_data[:set], observed_data[:set])
      }
    end
  end

  def error(expected_datetime, observed_datetime)
    ((expected_datetime - observed_datetime) * 1440).abs.to_f
  end
end
