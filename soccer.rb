# pseudocode
# 1. open file
# 2. parse over file
# 3. put each line into an array
# 4. delete unneeded rows
# 5. make rows uniform
# 6. assign rows to columns array
# 7. compare for column with against column for smallest difference
# 8. return team name associated with above condition

@array = []
@compare = []
@hash = Hash.new(0)

class SoccerData
  def initialize
    @soccer_data = []
    @sum_array = []
    @col_com_hash = Hash.new(0)
  end

  def open_file(file_name)
    File.open(file_name).each do |line|
      @soccer_data << line.split("\t")
    end
    return cleanse_data
  end

  def cleanse_data
    @soccer_data.map! do |row|
      row.map do |string|
        string.gsub!(/-/, "") #remove "-"
        string.gsub!(/\d{1,}\./, "") #remove team numbers
      end
      row.join(" ").split(" ")
    end
    return delete_unneeded_rows
  end

  def delete_unneeded_rows
    @soccer_data.delete_if do |row|
      row[0] == "<pre>" || row[0] == "</pre>" || row[0] == nil
    end
    return make_columns
  end

  def make_columns
    @col_data = @soccer_data.transpose
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

smallest_for_against = SoccerData.new
smallest_for_against.open_file("data/soccer.dat")
smallest_for_against.col_calculation(6,7, "-")
smallest_for_against.choose_result_col("Team")