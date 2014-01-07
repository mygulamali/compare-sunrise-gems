require_relative 'lib/data_comparator'

def usno_data_filename
  "./data/2013-usno-data.txt"
end

def csv_errors_filename
  extension = File.extname(usno_data_filename)
  basename = File.basename(usno_data_filename, extension)
  dirname = File.dirname(usno_data_filename)
  File.join(dirname, "#{basename}-errors.csv")
end

task :default => :compare

desc "Compare sunrise/sunset timings between USNO data and gems"
task :compare do
  comparator = DataComparator.new usno_data_filename
  comparator.calculate_data
  comparator.calculate_errors
  comparator.output_errors csv_errors_filename
end
