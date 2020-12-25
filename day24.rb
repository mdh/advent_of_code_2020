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

input = File.read('day24_input.txt')
test_input =<<EOT
sesenwnenenewseeswwswswwnenewsewsw
neeenesenwnwwswnenewnwwsewnenwseswesw
seswneswswsenwwnwse
nwnwneseeswswnenewneswwnewseswneseene
swweswneswnenwsewnwneneseenw
eesenwseswswnenwswnwnwsewwnwsene
sewnenenenesenwsewnenwwwse
wenwwweseeeweswwwnwwe
wsweesenenewnwwnwsenewsenwwsesesenwne
neeswseenwwswnwswswnw
nenwswwsewswnenenewsenwsenwnesesenew
enewnwewneswsewnwswenweswnenwsenwsw
sweneswneswneneenwnewenewwneswswnese
swwesenesewenwneswnwwneseswwne
enesenwswwswneneswsenwnewswseenwsese
wnwnesenesenenwwnenwsewesewsesesew
nenewswnwewswnenesenwnesewesw
eneswnwswnwsenenwnwnwwseeswneewsenese
neswnwewnwnwseenwseesewsenwsweewe
wseweeenwnesenwwwswnew
EOT

tile_paths = input.strip.lines.map do |line|
  line.strip.split(/(se|sw|nw|ne|e|w|)/).reject &:empty?
end
# floor can be modeled as following:
# .x.x.x.
# x.x.x.x
# .x.x.x.
# e/w is 2 positions in x direction
# ne/nw/sw/se is 1 pos in x and 1 in y

def follow_tile_path(tile_path)
  tile_path.map do |step|
    case step
    when 'e'  then [ 2, 0]
    when 'w'  then [-2, 0]
    when 'ne' then [ 1, 1]
    when 'nw' then [-1, 1]
    when 'se' then [ 1,-1]
    when 'sw' then [-1,-1]
    end
  end.reduce([0,0]) { |sum, step| sum[0] += step[0]; sum[1] += step[1]; sum }
end

black_tiles = tile_paths.map { |tile_path| follow_tile_path tile_path }.tally.to_a.reject { |coords, flips| flips.even? }.map &:first
pp black_tiles.size

# part 2

def adjacent_tile_coords(x,y)
  [
    [ 2, 0], [-2, 0], [ 1, 1], [-1, 1], [ 1,-1], [-1,-1]
  ].map { |x2,y2| [x + x2, y + y2] }
end

tiles = {}
tile_paths.map { |tile_path| follow_tile_path tile_path }.tally.each do |coords, flips|
  tiles[coords] = flips.even? ? :white : :black
end

100.times do |i|
  new_tiles = {}
  tiles.to_a.each do |coords, color|
    adjacent_tile_coords(*coords).each do |adj_coords|
      tiles[adj_coords] ||= :white
    end
  end
  tiles.each do |coords, color|
    adjacent_tile_coords = adjacent_tile_coords(*coords)
    adjacent_black = adjacent_tile_coords.map {|_coords| tiles[_coords]}.select {|color| color == :black}.size
    if color == :black
      if adjacent_black == 0 || adjacent_black > 2
        new_tiles[coords] = :white
      else
        new_tiles[coords] = :black
      end
    else
      if adjacent_black == 2
        new_tiles[coords] = :black
      else
        new_tiles[coords] = :white
      end
    end
  end
  tiles = new_tiles
  pp "Day #{i + 1}: #{tiles.values.select {|c| c == :black}.size}"
end
