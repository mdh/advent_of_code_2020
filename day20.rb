# Add tally from ruby 2.7 (because i am lazy)
[Enumerable, Array].each do |clazz|
  clazz.class_eval do
    def tally
      each_with_object({}) do |v, acc|
        acc[v] ||= 0
        acc[v] += 1
      end
    end
  end
end

input = File.read('day20_input.txt')
test_input =<<EOT
Tile 2311:
..##.#..#.
##..#.....
#...##..#.
####.#...#
##.##.###.
##...#.###
.#.#.#..##
..#....#..
###...#.#.
..###..###

Tile 1951:
#.##...##.
#.####...#
.....#..##
#...######
.##.#....#
.###.#####
###.##.##.
.###....#.
..#.#..#.#
#...##.#..

Tile 1171:
####...##.
#..##.#..#
##.#..#.#.
.###.####.
..###.####
.##....##.
.#...####.
#.##.####.
####..#...
.....##...

Tile 1427:
###.##.#..
.#..#.##..
.#.##.#..#
#.#.#.##.#
....#...##
...##..##.
...#.#####
.#.####.#.
..#..###.#
..##.#..#.

Tile 1489:
##.#.#....
..##...#..
.##..##...
..#...#...
#####...#.
#..#.#.#.#
...#.#.#..
##.#...##.
..##.##.##
###.##.#..

Tile 2473:
#....####.
#..#.##...
#.##..#...
######.#.#
.#...#.#.#
.#########
.###.#..#.
########.#
##...##.#.
..###.#.#.

Tile 2971:
..#.#....#
#...###...
#.#.###...
##.##..#..
.#####..##
.#..####.#
#..#.#..#.
..####.###
..#.#.###.
...#.#.#.#

Tile 2729:
...#.#.#.#
####.#....
..#.#.....
....#..#.#
.##..##.#.
.#.####...
####.#.#..
##.####...
##..#.##..
#.##...##.

Tile 3079:
#.#.#####.
.#..######
..#.......
######....
####.#..#.
.#...#.##.
#.#####.##
..#.###...
..#.......
..#.###...
EOT

# part 1
Tile = Struct.new :number, :data do
  def top
    data.first.join
  end

  def top_i
    top.to_i 2
  end

  def bottom
    data.last.join
  end

  def bottom_i
    bottom.to_i 2
  end

  def left
    data.map(&:first).join
  end

  def left_i
    left.to_i 2
  end

  def right
    data.map(&:last).join
  end

  def right_i
    right.to_i 2
  end

  def edges
    (
      [top, left, bottom, right] +
      [top, left, bottom, right].map(&:reverse)
    ).map { |b| b.to_i 2 }
  end

  def rotate
    rotated = []
    data.each.with_index do |row, x|
      row.each.with_index do |char, y|
        rotated[y] ||= []
        rotated[y][x] = char
      end
    end
    self.data = rotated
  end

  def flip
    self.data = data.reverse
  end
end

tiles = input.split("\n\n").map do |tile_txt|
  number, *data = tile_txt.strip.lines.map(&:strip)
  Tile.new number.split.last.to_i, data.map {|row| row.gsub('.', '0').gsub('#', '1').chars}
end

possible_edges = tiles.flat_map {|t| t.edges }.sort
possible_edge_count = possible_edges.tally
valid_edges = possible_edge_count.reject {|_,v| v < 2 }.keys

corners = tiles.select { |tile| (valid_edges & tile.edges.uniq).size == 4 }
pp corners.map(&:number).map(&:to_i).reduce(:*)

# part 2

def find_tile(tiles, top=nil, left=nil)
  edges = (Array(top) + Array(left)).compact
  tiles.find { |tile| (tile.edges & edges) == edges }
end

top_left = nil
while top_left = nil
  top_left = corners.find { |tile| valid_edges.include?(tile.right.to_i(2)) && valid_edges.include?(tile.bottom.to_i(2)) }
  top_left || corners.map(&:flip)
end

grid = []
last = top_left
12.times.each do |x|
  12.times.each do |y|
    prev_row = grid[x - 1] || []
    top = prev_row[y]&.bottom_i
    tile = find_tile(tiles, top, last&.right_i)
    grid[x] ||= []
    grid[x][y] = tile
    last = tile
  end
  last = nil
end
pp grid.map { |r| r.map &:number }
