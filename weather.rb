# pseudocode
# 1. open file
# 2. parse over file
# 3. put each line into an array
# 4. delete unneeded rows
# 5. make rows uniform
# 6. assign rows to columns array
# 7. compare column 2 to column 3 for smallest difference
# 8. return column number associated with above condition

class WeatherData
  def initialize
    @weather_data = []
    @compare = []
    @hash = Hash.new(0)
  end

  def open_file(file)
    File.open(file).each do |line|
      @weather_data << line.split("\t")
    end
    return make_rows_uniform
  end

  def make_rows_uniform
    @weather_data.map! do |row|
      row.map do |string|
        string.gsub!(/\s{8,}/, " #{0} ") #replace >=8 whitespaces w/ 0
        string.gsub!(/1HrP/, "") #delete header w/ no data
        string.gsub!(/\*/, "") #delete asterisk
      end
      row.join(" ").split(" ")
    end
    return delete_unneeded_rows
  end

  def delete_unneeded_rows
    @weather_data.delete_if do |row|
      row[0] == "<pre>" || row[0] == "</pre>" || row[0] == nil || row[0] == "MMU" || row[0] == "mo"
    end
    return make_columns
  end

  def make_columns
    @columns = @weather_data.transpose
  end

  def min_temp_spread(col_a, col_b, operator)
    @columns[col_a-1].zip(@columns[col_b-1]).each do |mxt, mnt|
      @compare << (mxt.to_i.send(operator, mnt.to_i))
    end
  end

  def col_comparison
    #using days column to zip the sum of mxt minus mnt
    @columns[0].zip(@compare).each do |day, sum|
      @hash[day] = sum if day != "Dy" #don't include header
    end
    return @hash.sort_by {|key, value| value}.first[0]
  end
end

temperature_spread = WeatherData.new
temperature_spread.open_file("data/w_data.dat")
temperature_spread.min_temp_spread(2,3, "-")
p temperature_spread.col_comparison