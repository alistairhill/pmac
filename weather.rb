# pseudocode
# 1. open file
# 2. parse over file
# 3. put each line into an array
# 4. delete unneeded rows
# 5. make rows uniform
# 6. assign rows to columns array
# 7. compare column 2 to column 3 for smallest difference
# 8. return column number associated with above condition

# Dy MxT   MnT
# 1  88    59
# 2  79    63

@array = []
@row = []
@column = []

def open_file(file)
  File.open(file).each do |line|
    @array << line.split(" ")
  end
  print @array
end





open_file("data/w_data.dat")