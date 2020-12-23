input = File.read('day22_input.txt')
test_input =<<EOT
Player 1:
9
2
6
3
1

Player 2:
5
8
4
7
10
EOT

player1, player2 = input.split("\n\n").map { |part| lines = part.strip.lines; lines.shift; lines.map &:to_i }

# part 1
while player1.size > 0 && player2.size > 0 do
  card1 = player1.shift
  card2 = player2.shift
  if card1 > card2
    # player 1 wins
    player1 << card1
    player1 << card2
  else
    player2 << card2
    player2 << card1
  end
end
pp player2.empty? ? 'Player 1 won' : 'Player 2 won'
winner = [player1, player2].sort_by(&:size).last
pp winner.reverse.map.with_index { |card,index| card * (index + 1) }.reduce(:+)

# part 2
pp
pp 'part 2'
#player1, player2 = input.split("\n\n").map { |part| lines = part.strip.lines; lines.shift; lines.map &:to_i }
player1, player2 = test_input.split("\n\n").map { |part| lines = part.strip.lines; lines.shift; lines.map &:to_i }

def play_game(player1, player2)
  #pp "Player1: #{player1.inspect}"
  #pp "Player2: #{player2.inspect}"
  winner = nil
  card1 = player1.shift
  card2 = player2.shift
  #pp "Player1 draws: #{card1}"
  #pp "Player2 draws: #{card2}"
  if card1 <= player1.size && card2 <= player2.size
    #pp "Starting sub game"
    player1_sub = player1[0, card1]
    player2_sub = player2[0, card2]
    if player1_sub.size == 0
      winner = :player2
    elsif player2_sub.size == 0
      winner = :player1
    else
      previous_round_sub_states = []
      while player1_sub.size > 0 && player2_sub.size > 0 do
        sub_state = player1_sub + player2_sub
        if previous_round_sub_states.include? sub_state
          winner = :player1
          break
        else
          previous_round_sub_states << sub_state
          winner = play_game(player1_sub, player2_sub)
        end
      end
    end
    if winner == :player1
      player1 << card1
      player1 << card2
    else
      player2 << card2
      player2 << card1
    end
    #pp "Back to game"
  else
    if card1 > card2
      #pp "Player1 wins!"
      player1 << card1
      player1 << card2
      winner = :player2
    else
      #pp "Player2 wins!"
      player2 << card2
      player2 << card1
      winner = :player2
    end
  end
  winner
end

while player1.size > 0 && player2.size > 0 do
  pp player1.size
  play_game player1, player2
end
pp "player 1: #{player1.inspect}"
pp "player 2: #{player2.inspect}"
winner = [player1, player2].sort_by(&:size).last
pp winner.reverse.map.with_index { |card,index| card * (index + 1) }.reduce(:+)


