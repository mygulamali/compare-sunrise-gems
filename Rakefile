require_relative 'lib/data_comparator'

def filename_components(filename)
  extension = File.extname(filename)
  {
   ext: extension,
   base: File.basename(usno_data_filename, extension),
   dir: File.dirname(usno_data_filename)
  }
end

def usno_data_filename
  "./data/2013-usno-data.txt"
end

def csv_errors_filename
  components = filename_components(usno_data_filename) 
  File.join(components[:dir], "#{components[:base]}-errors.csv")
end

def errors_plot_filename
  components = filename_components(usno_data_filename)
  File.join(components[:dir], "#{components[:base]}-errors.png")
end

task :default => :compare

desc "Compare sunrise/sunset timings between USNO data and gems."
task :compare do
  comparator = DataComparator.new usno_data_filename
  comparator.calculate_data
  comparator.calculate_errors
  comparator.output_errors csv_errors_filename
end

desc "Plot errors to PNG file (requires gnuplot)."
task :plot do
  sh [
    "gnuplot",
    "-e 'the_data=\"#{csv_errors_filename}\"; the_plot=\"#{errors_plot_filename}\"'",
    "./lib/plot_errors.gnuplot"
  ].join(' ')
end
