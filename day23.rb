test_input = "389125467"
input = "496138527"

# part1
class Circle
  attr_reader :cups, :current

  def initialize(cups)
    @cups = cups
    @current = @cups.first
  end

  def position(cup)
    @cups.find_index cup
  end

  def pickup
    3.times.map do
      position = (position(@current) + 1) % @cups.size
      next_cup = @cups.at(position)
      @cups.delete next_cup
    end
  end

  def select_destination
    value = @current - 1
    destination = nil
    while true
      if destination = @cups.bsearch { |cup| cup == value }
        break
      else
        value -= 1
        if value < 1
          value = @cups.max
        end
      end
    end
    destination
  end

  def insert(destination, cups)
    cups.each.with_index do |cup, index|
      position = @cups.find_index { |cup| cup == destination }
      @cups.insert(position + index, cup)
    end
  end

  def select_current
    position = position(@current) + 1
    @current = @cups[position % @cups.size]
  end

  def move
    cups = pickup
    destination = select_destination
    insert(destination, cups)
    select_current
  end
end


circle = Circle.new test_input.split(//).map &:to_i
10.times { circle.move }
pp circle.cups, circle.current

circle = Circle.new input.split(//).map &:to_i
100.times { circle.move }
pp circle.cups, circle.current

