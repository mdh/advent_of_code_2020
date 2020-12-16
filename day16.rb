input = File.read('day16_input.txt')
require 'set'

test_input = <<EOT
class: 1-3 or 5-7
row: 6-11 or 33-44
seat: 13-40 or 45-50

your ticket:
7,1,14

nearby tickets:
7,3,47
40,4,50
55,2,20
38,6,12
EOT

# part 1

rules_txt, your_ticket_txt, nearby_tickets_txt = input.strip.split("\n\n")
rules = rules_txt.lines.flat_map { |l| l.split.grep(/\d/).flat_map { |range| a, b = range.split('-').map &:to_i; a..b } }
valid_values = {}
rules.each { |rule| rule.to_a.each {|v| valid_values[v] = true } }
nearby_tickets = nearby_tickets_txt.lines
nearby_tickets.shift

error_rate = 0
nearby_tickets.each do |ticket|
  ticket.split(',').each { |value| value = value.to_i; error_rate += value unless valid_values[value] }
end
pp error_rate


# part 2

valid_tickets = nearby_tickets.reject do |ticket|
  ticket.split(',').find { |value| valid_values[value.to_i] == nil }
end.map {|t| t.split(',').map &:to_i}

rules = {}
rules_txt.lines.each do |line|
  label, range_txt = line.split(': ', 2)
  ranges = range_txt.split(' or ').map {|txt| a,b = txt.split('-').map(&:to_i); a..b}
  rules[label] = ranges
end

possible_fields = {}
rules.each do |rule|
  label, ranges = rule
  rules.size.times do |index|
    possible_fields[label] ||= Set.new
    if valid_tickets.all? { |ticket| ranges.any? { |range| range.include? ticket[index] } }
      possible_fields[label] << index
    end
  end
end

possible_fields.to_a.sort_by {|f, indexes| indexes.size }.each do |label, indexes|
  if indexes.size == 1
    value = indexes.first
    possible_fields
      .find_all { |_, indexes| indexes.size > 1 }
      .each { |_, indexes| indexes.delete value }
  end
end

your_ticket = your_ticket_txt.split(',').map &:to_i
pp possible_fields
  .find_all { |label, _| label =~ /departure/ }
  .map { |_, index| your_ticket[index.first] }.reduce :*
