input = <<EOT
10441485
1004920
EOT
test_input = <<EOT
5764801
17807724
EOT
card_pub_key, door_pub_key = input.strip.lines.map &:to_i

def calc_loop_size(key, subject_number)
  value = 1
  loop_size = 0
  while value != key
    value *= subject_number
    value = value % 20201227
    loop_size += 1
  end
  [loop_size, value]
end

def transform(subject_number, loop_size)
  value = 1
  loop_size.times do
    value *= subject_number
    value = value % 20201227
    loop_size += 1
  end
  value
end

card_loop_size, card_pub_key = calc_loop_size card_pub_key, 7
door_loop_size, door_pub_key = calc_loop_size door_pub_key, 7

pp encryption_key1 = transform(door_pub_key, card_loop_size)
pp encryption_key2 = transform(card_pub_key, door_loop_size)
pp encryption_key1 == encryption_key2
