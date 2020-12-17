require 'set'
input = File.read('day17_input.txt')

test_input = <<EOT
.#.
..#
###
EOT

# part 1
Cube = Struct.new(:x, :y, :z, :w, :active) do
  include Comparable

  def <=>(other)
    [x, y, z, w] <=> [other.x, other.y, other.z, other.w]
  end

  def hash
    x + y + z + w
  end
end

grid = Set.new
input.lines.map.with_index do |line, x|
  line.strip.chars.map.with_index do |c, y|
    grid << Cube.new(x, y, 0, 0, (c == '#'))
  end
end

def relative_neighbour_coords
  @relative_coords ||= [-1,-1,-1,-1,0,0,0,0,1,1,1,1].permutation(4).uniq - [[0,0,0,0]]
end

def neighbours(grid, cube)
  relative_neighbour_coords.map do |dx,dy,dz,dw|
    grid.find do |other|
      (cube.x + dx == other.x) && (cube.y + dy == other.y) && (cube.z + dz == other.z) && (cube.w + dw == other.w)
    end || Cube.new(cube.x + dx, cube.y + dy, cube.z + dz, cube.w + dw, false)
  end
end

6.times do |cycle|
  new_grid = Set.new
  grid.each do |cube|
    # determine state for all neighbours
    neighbours(grid, cube).each do |neighbour|
      active_count = 0
      neighbours(grid, neighbour).each do |c|
        break if active_count > 3
        active_count += 1 if c.active
      end
      # add neighbours to new_grid
      if (neighbour.active && [2,3].include?(active_count)) ||
      (!neighbour.active && active_count == 3)
        new_cube = Cube.new *neighbour.to_h.values
        new_cube.active = true
        new_grid << new_cube
      else # skip
      end
    end
  end
  puts "After cycle #{cycle + 1}: #{ new_grid.count }"
  grid = new_grid
end
