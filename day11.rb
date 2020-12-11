# Add tally from ruby 2.7 (because i am lazy)

input = File.read('day11_input.txt')

test_input = <<EOT
L.LL.LL.LL
LLLLLLL.LL
L.L.L..L..
LLLL.LL.LL
L.LL.LL.LL
L.LLLLL.LL
..L.L.....
LLLLLLLLLL
L.LLLLLL.L
L.LLLLL.LL
EOT

# part 1
EmptySeat = 'L'
Occupied  = '#'
Floor     = '.'

def adjacent(seats, x, y)
  result = Hash.new { 0 }
  for i in (x-1)..(x+1)
    for j in (y-1)..(y+1)
      next if i < 0 || j < 0
      next if x == i && y == j
      row = seats[i]
      next if row.nil?
      state = row[j]
      result[state] += 1
    end
  end
  result
end

def map_seats(seats)
  new_seats = []
  seats.each.with_index do |row, x|
    new_seats[x] = []
    row.each.with_index do |seat, y|
      new_seats[x][y] = yield(seat, x, y)
    end
  end
  new_seats
end

def sit(seats)
  map_seats(seats) do |seat, x, y|
    if seat == EmptySeat
      adjacent(seats, x, y)[Occupied] == 0 ? Occupied : EmptySeat
    else
      seat
    end
  end
end

def leave(seats)
  map_seats(seats) do |seat, x, y|
    if seat == Occupied
      adjacent(seats, x, y)[Occupied] >= 4 ? EmptySeat : Occupied
    else
      seat
    end
  end
end

seats = input.strip.lines.map(&:strip).map(&:chars)

while true
  new_seats = sit(seats)
  new_seats = leave(new_seats)
  if seats != new_seats
    puts 'next round...'
    seats = new_seats
  else
    puts seats.flatten.find_all { |s| s == Occupied }.size
    break
  end
end
