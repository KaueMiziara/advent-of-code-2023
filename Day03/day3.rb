# Sum all the numbers in the input file that are adjacent to a symbol.
# The number is adjacent to a symbol if the difference in their "coordinates"
# equals one.
# number[i][j] -> number[i-1][j-1] <= symbol <= number[i+1][j+1]

class String
  def integer?
    self.to_i.to_s == self
  end

  def symbol?
    if self.match(/[^0-9.]/)
      return true
    end

    return false
  end
end

class Position
  attr_reader :i, :j

  def initialize(i, j)
    @i = i
    @j = j
  end

  def +(obj)
    return Position.new(self.i + obj.i, self.j + obj.j)
  end

  def ==(obj)
    return (self.i == obj.i) && (self.j == obj.j)
  end

  def to_s
    "{#{self.i}, #{self.j}}"
  end
end

class Number
  attr_reader :value, :position, :right_digit, :left_digit
  
  def initialize(value, position)
    @value = value.to_i
    @position = position
  end

  def adjacent_to_symbol?(array)
    positions = [
      self.position + Position.new(-1, -1),
      self.position + Position.new(-1, 0),
      self.position + Position.new(-1, +1),

      self.position + Position.new(0, -1),
      self.position + Position.new(0, +1),

      self.position + Position.new(+1, -1),
      self.position + Position.new(+1, 0),
      self.position + Position.new(+1, +1),
    ]

    len = array.length
    for pos in positions
      if (pos.i >= 0 && pos.j >= 0) && (pos.i < len && pos.j < len)
        if array[pos.i][pos.j].symbol?
          return true
        end
      end
    end

    return false
  end

  def make_number_in_array(array)
    i = self.position.i
    j = self.position.j + 1
    next_element = array[i][j]

    if next_element.integer?
      next_element = next_element.to_i

      value = self.value * 10 + next_element 
      return GearNumber.new(value, [Position.new(i, j - 1), Position.new(i, j)])
    else
      return -1
    end
  end

  def to_s
    "#{self.value} -> #{self.position}"
  end
end

class GearNumber
  attr_reader :value, :positions

  def initialize(value, positions)
    @value = value
    @positions = positions
  end
end

FormattedNumber = Struct.new(:values, :positions)

def generate_matrix(file_name)
  file = File.open(file_name, "r")
  data = file.read().split("\n")
  file.close()

  matrix = []
  for line in data
    line_chars = line.split('')
    matrix.append(line_chars)
  end
  
  return matrix
end

def arrange_numbers(numbers)
  values = []

  val = []
  for n in numbers
    if n != -1
      val.append(n)
    else
      values.append(val)
      val = []
    end
  end
  
  return values
end

def format_numbers(array)
  nums = []
  pos = []

  for set in array
    if set.length() > 1
      n1 = set[0]
      n2 = set[1]
      ns = [n1.value, n2.value]

      n = ns.join('')
      n[1] = ''

      nums.append(n)

      ps = n1.positions | n2.positions
      pos.append(ps)
    else
      nums.append(set[0].value)
      pos.append(set[0].positions)
    end
  end

  # return FormattedNumber.new(nums, pos)
  return GearNumber.new(nums, pos)
end

def main
  matrix = generate_matrix("input.txt")
  matrix_numbers = [] # digits in the matrix
  gear_parts = []     # digits adjacent to a symbol
  numbers = []        # formatted numbers
  part_numbers = []   # formatted numbers adjacent to a symbol

  for i in matrix.each_index
    for j in matrix[i].each_index
      item = matrix[i][j]

      if item.integer?
        matrix_numbers.append(Number.new(item, Position.new(i, j)))
      end
    end
  end

  for n in matrix_numbers
    if n.adjacent_to_symbol?(matrix)
      gear_parts.append(n)
    end
  end

  for n in matrix_numbers
    numbers.append(n.make_number_in_array(matrix))
  end

  numbers = arrange_numbers(numbers)
  numbers = format_numbers(numbers)

  for part in gear_parts
    for i in numbers.positions.each_index
      for pos in numbers.positions[i]
        if part.position == pos
          part_numbers.append(numbers.value[i].to_i)
        end
      end
    end
  end

  part_numbers = part_numbers.uniq
  puts part_numbers.reduce(:+)
end

main
