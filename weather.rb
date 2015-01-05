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
    @sum_array = []
    @col_com_hash = Hash.new(0)
  end

  def open_file(file_name)
    File.open(file_name).each do |line|
      @weather_data << line.split("\t")
    end
    return cleanse_data
  end

  def cleanse_data
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
      row.first == "<pre>" || row.first == "</pre>" || row.first == nil || row.first == "MMU" || row.first == "mo"
    end
    return make_columns
  end

  def make_columns
    @col_data = @weather_data.transpose
  end

  def col_calculation(col_a, col_b, operator)
    #zip two columns together to execute calculation
    @col_data[col_a-1].zip(@col_data[col_b-1]).each do |col_1, col_2|
      @sum_array << (col_1.to_i.send(operator, col_2.to_i))
    end
  end

  def choose_result_col(col_name_string)
    @col_data.each_with_index do |col, index|
      return col_comparison(index) if col.first == col_name_string
    end
  end

  def col_comparison(res_col_num)
    #zip chosen result column with sum of col_calculation column
    @col_data[res_col_num].zip(@sum_array).each do |result_col, sum|
      #add result col & sum col to hash for returning the corresponding lowest difference
      @col_com_hash[result_col] = sum if result_col != @col_data[res_col_num].first
    end
    return @col_com_hash.min_by {|key, value| value.abs}.first
  end
end

temperature_spread = WeatherData.new
temperature_spread.open_file("data/w_data.dat")
temperature_spread.col_calculation(2,3, "-")
temperature_spread.choose_result_col("Dy")