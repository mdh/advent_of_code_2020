require 'set'
input = File.read('day17_input.txt')

test_input = <<EOT
.#.
..#
###
EOT

grid = {}
input.lines.each.with_index do |line, x|
  line.strip.chars.each.with_index do |c, y|
    grid[[x, y, 0, 0]] = (c == '#')
  end
end

def relative_neighbour_coords
  @relative_coords ||= [-1,-1,-1,-1,0,0,0,0,1,1,1,1].permutation(4).uniq - [[0,0,0,0]]
end

def neighbours(grid, coords)
  results = {}
  relative_neighbour_coords.map do |dx,dy,dz,dw|
    x,y,z,w = [coords[0] + dx, coords[1] + dy, coords[2] + dz, coords[3] + dw]
    results[[x,y,z,w]] = grid[[x,y,z,w]] || false
  end
  results
end

6.times do |cycle|
  new_grid = {}
  grid.each do |coords, value|
    # determine state for all neighbours
    neighbours(grid, coords).each do |neighbour_coords, value2|
      active_count = 0
      neighbours(grid, neighbour_coords).each do |_, value3|
        break if active_count > 3
        active_count += 1 if value3
      end
      # add neighbours to new_grid
      if (value2 && [2,3].include?(active_count)) ||
      (!value2 && active_count == 3)
        new_grid[neighbour_coords] = true
      else # skip
      end
    end
  end
  puts "After cycle #{cycle + 1}: #{ new_grid.size }"
  grid = new_grid
end
