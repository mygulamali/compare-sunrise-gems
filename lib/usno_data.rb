require 'date'
require_relative 'my_data'

class USNO_Data < MyData
  attr_reader :lines

  def initialize(filename)
    if not File.exist?(filename)
      return nil
    end
    @lines = File.open(filename, 'r') { |file| file.readlines }

    year = get_year(lines[1])
    lat, lng = get_location(lines[1])
    super(year, lat, lng)
  end

  def calculate
    get_times(lines.slice!(9, 31))
  end
  
  private

  def get_year(data)
    data[80..85].strip.to_i
  end

  def get_location(data)
    lat_string = data[19..24]
    lng_string = data[10..16]

    lat = lat_string[1..2].to_f + lat_string[4..5].to_f/60.0
    if lat_string[0] == 'S'
      lat *= -1
    end

    lng = lng_string[1..3].to_f + lng_string[5..6].to_f/60.0
    if lng_string[0] == 'W'
      lng *= -1
    end

    [lat, lng]
  end

  def get_times(data)
    @times = []

    data.each do |line|
      day = line[0..1].to_i
      (0..11).each do |month|
        sunrise_range = (4 + month*11)...(8 + month*11)
        sunset_range = (9 + month*11)...(13 + month*11)

        if not line[sunrise_range.begin...sunset_range.end].strip.empty?
          @times << {
            rise: DateTime.strptime(
              "#{year} #{month + 1} #{day} #{line[sunrise_range]}", "%Y %m %d %H%M"
            ),
            set: DateTime.strptime(
              "#{year} #{month + 1} #{day} #{line[sunset_range]}", "%Y %m %d %H%M"
            )
          }
        end
      end
    end

    @times.sort_by! { |time| time[:rise].yday }
  end
end
