require 'set'
input = File.read('day17_input.txt')

test_input = <<EOT
.#.
..#
###
EOT

# part 1
Cube = Struct.new(:x, :y, :z, :active) do
  include Comparable

  def <=>(other)
    [x, y, z] <=> [other.x, other.y, other.z]
  end
end

grid = []
input.lines.map.with_index do |line, x|
  line.strip.chars.map.with_index do |c, y|
    grid << Cube.new(x, y, 0, (c == '#'))
  end
end

def relative_neighbour_coords
  @relative_coords ||= [-1,-1,-1,0,0,0,1,1,1].permutation(3).uniq - [[0,0,0]]
end

def neighbours(grid, cube)
  relative_neighbour_coords.map do |dx,dy,dz|
    grid.find do |other|
      (cube.x + dx == other.x) && (cube.y + dy == other.y) && (cube.z + dz == other.z)
    end || Cube.new(cube.x + dx, cube.y + dy, cube.z + dz, false)
  end
end

6.times do |cycle|
  new_grid = Set.new
  grid.find_all { |c| c.active }.each do |cube|
    # determine state for all neighbours
    neighbours(grid, cube).each do |neighbour|
      active_count = neighbours(grid, neighbour).find_all { |c| c.active }.size
      # add neighbours to new_grid
      new_cube = Cube.new *neighbour.to_h.values
      if neighbour.active && [2,3].include?(active_count)
        new_cube.active = true
      elsif !neighbour.active && active_count == 3
        new_cube.active = true
      else
        new_cube.active = false
      end
      new_grid << new_cube
    end
  end
  puts "After cycle #{cycle + 1}: #{ new_grid.find_all {|c| c.active}.count }"
  grid = new_grid
end
