# pseudocode
# 1. open file
# 2. parse over file
# 3. put each line into an array
# 4. delete unneeded rows
# 5. make rows uniform (rows should have 17 values)
# 6. assign rows to columns array
# 7. compare column 2 to column 3 for smallest difference
# 8. return column number associated with above condition

@array = []
@compare = []

def open_file(file)
  File.open(file).each do |line|
    @array << line.split("\t")
  end
end

def make_rows_uniform
  @array.map! do |row|
    row.map do |string|
      string.gsub!(/\s{8,}/, " #{0} ") #replace >=8 whitespaces w/ 0
      string.gsub!(/1HrP/, "") #delete header w/ no data
      string.gsub!(/\*/, "") #delete asterisk
    end
    row.join(" ").split(" ")
  end
end

def delete_unneeded_rows
  @array.delete_if do |row|
    row[0] == "<pre>" || row[0] == "</pre>" || row[0] == nil || row[0] == "MMU" || row[0] == "mo"
  end
end

def make_columns
  @columns = @array.transpose
end

def min_temp_spread(col_a, col_b)
  @columns[col_a-1].zip(@columns[col_b-1]).each do |mxt, mnt|
    @compare << (mxt.to_i - mnt.to_i)
  end
end

def col_comparison
  #using days column to zip the sum of mxt minus mnt
  @columns[0].zip(@compare).each do |day, sum|
    @hash[day] = sum if day != "Dy" #don't include header
  end
  return @hash.sort_by {|key, value| value}.first[0]
end

open_file("data/w_data.dat")
make_rows_uniform
delete_unneeded_rows
make_columns
min_temp_spread(2,3)
p col_comparison