test_input = "389125467"
input = "496138527"

# part1
class Circle
  attr_reader :cups, :current

  def initialize(cups)
    @max_cup = cups.max
    @current = cups.first
    @cups = {}
    cups.each.with_index { |cup, index| @cups[cup] = cups[(index + 1)] || cups[0] }
  end

  def pickup
    next_cup1 = @cups[@current]
    next_cup2 = @cups[next_cup1]
    next_cup3 = @cups[next_cup2]
    [next_cup1, next_cup2, next_cup3]
  end

  def select_destination(picked_up_cups)
    destination = @current - 1
    destination = @max_cup if destination < 1
    while picked_up_cups.include? destination
      destination -= 1
      destination = @max_cup if destination < 1
    end
    destination
  end

  def insert(destination, picked_up_cups)
    first_picked_up  = picked_up_cups.first
    last_picked_up   = picked_up_cups.last

    current_next     = @cups[last_picked_up]
    destination_next = @cups[destination]

    @cups[@current]       = current_next
    @cups[last_picked_up] = destination_next
    @cups[destination]    = first_picked_up
  end

  def select_current
    @current = @cups[@current]
  end

  def move
    #pp @cups
    cups = pickup
    #pp "Pick up #{cups}"
    destination = select_destination(cups)
    #pp "Destination: #{destination}"
    insert(destination, cups)
    select_current
  end
end

circle = Circle.new input.strip.split(//).map &:to_i
100.times { circle.move }
pp circle

 #part 2
input2 = input.split(//).map &:to_i
input2 += (10..1_000_000).to_a
circle = Circle.new input2
(input2.max * 10).times.with_index do |index|
  circle.move
end
#pp pos = circle.position(1)
pos = 1
pp 2.times.map { pos = circle.cups[pos] }.reduce(:*)

