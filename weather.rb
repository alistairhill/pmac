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
@row = []
@column = []

def open_file(file_name)
  File.open(file_name).each do |line|
    @array << line.split("\t")
  end
end

def add_values_for_tabs
  @array.map! do |row|
    row.map do |string|
      string.gsub!(/\s{7,}/, " x ")
      # string.gsub!(/[A-Z]\s[x]/, " ")
    end
    row.join(" ").split(" ")
  end
end

def make_rows_uniform
  @array.each do |row|
    p row.length
  end
end

def delete_unneeded_rows
  @array.delete_if do |row|
    row[0] == "<pre>" || row[0] == "</pre>" || row[0] == nil || row[0] == "MMU"
  end
  print @array
end

open_file("data/w_data.dat")
add_values_for_tabs
delete_unneeded_rows
make_rows_uniform