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
  directions = [-1, 0, 1].product([-1, 0, 1]).to_a - [[0,0]]
  directions.sort.each do |dx, dy|
    new_x = x + dx
    new_y = y + dy
    next if (new_x < 0) || (new_y < 0)
    row = seats[new_x] || []
    seat = row[new_y]
    result[seat] += 1
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

def run(seats)
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
end

run seats

# part 2
def adjacent(seats, x, y)
  max_dist = [seats.size, seats.first.size].max
  result = Hash.new { 0 }
  directions = [-1, 0, 1].product([-1, 0, 1]).to_a - [[0, 0]]
  directions.sort.each do |dx, dy|
    for dist in 1..max_dist
      new_x = x + dx*dist
      new_y = y + dy*dist
      next if (new_x < 0) || (new_y < 0)
      row = seats[new_x] || []
      seat = row[new_y]
      result[seat] += 1
      break if seat == Occupied || seat == EmptySeat
    end
  end
  result
end

def leave(seats)
  map_seats(seats) do |seat, x, y|
    if seat == Occupied
      adjacent(seats, x, y)[Occupied] >= 5 ? EmptySeat : Occupied
    else
      seat
    end
  end
end

run seats
