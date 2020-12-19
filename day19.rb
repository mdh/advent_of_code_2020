input = File.read('day19_input.txt')

test_input =<<EOT
0: 4 1 5
1: 2 3 | 3 2
2: 4 4 | 5 5
3: 4 5 | 5 4
4: "a"
5: "b"

ababbb
bababa
abbbab
aaabbb
aaaabbb
EOT

# 4 1 5
# "a" (2 3 | 3 2) "b"
# "a" ((4 4 | 5 5) (4 5 | 5 4) | (4 5 | 5 4) (4 4 | 5 5)) "b"
# "a" (("aa"|"bb") ("ab" | "ba") | ("ab" | "ba") ("aa" | "bb")) "b"
# part 1

rules_txt, messages_txt = input.split("\n\n")

rules = []
rules_txt.each_line.each do |line|
  index, rule = line.strip.split(': ')
  rules[index.to_i] = rule
end

messages = messages_txt.lines.map &:strip

resolved = rules[0]

while resolved =~ /\d/
  resolved = resolved.split.map do |word|
    case word
    when /\d/
      resolved_rule = rules[word.to_i]
      if resolved_rule.split.size > 1
        if resolved_rule =~ /\|/
          "( #{resolved_rule} )"
        else
          resolved_rule
        end
      else
        resolved_rule
      end
    else
      word
    end
  end.join(' ')
end

regex = /\A#{resolved.gsub(/["\s]/, '')}\z/
pp messages.grep(regex).size
