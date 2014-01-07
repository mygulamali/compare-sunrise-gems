class MyData
  attr_reader :year, :lat, :lng, :times

  def initialize(year, lat, lng)
    @year = year
    @lat = lat
    @lng = lng
  end

  def calculate
    raise NotImplementedError
  end
end
