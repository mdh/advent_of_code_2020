input = File.read('day4_input.txt').strip

# part 1
passports = input.split("\n\n").map &:strip
passports.find_all do |passport|
  parsed = Hash[*passport.split(/\s/).flat_map {|kp| kp.split(':')}]
  required_fields = %w[byr iyr eyr hgt hcl ecl pid]
  parsed.slice(*required_fields).values.find_all {|v| v.to_s.size > 0}.size == required_fields.size
end.size

# part 2
test_input =<<EOT
pid:087499704 hgt:74in ecl:grn iyr:2012 eyr:2030 byr:1980
hcl:#623a2f

eyr:2029 ecl:blu cid:129 byr:1989
iyr:2014 pid:896056539 hcl:#a97842 hgt:165cm

hcl:#888785
hgt:164cm byr:2001 iyr:2015 cid:88
pid:545766238 ecl:hzl
eyr:2022

iyr:2010 hgt:158cm hcl:#b6652a ecl:blu byr:1944 eyr:2021 pid:093154719
EOT

passports = input.split("\n\n").map &:strip

def valid?(data)
  (1920..2002).include?(data['byr'].to_i) &&
    (2010..2020).include?(data['iyr'].to_i) &&
    (2020..2030).include?(data['eyr'].to_i) &&
    (
      ( data['hgt'].to_s.match(/\A\d{3}cm\z/) && (150..193).include?(data['hgt'].to_i)) ||
      ( data['hgt'].to_s.match(/\A\d{2}in\z/) && (59..76).include?(data['hgt'].to_i))
    ) &&
    data['hcl'].to_s.match(/\A#[0-9a-f]{6}\z/) &&
    data['ecl'].to_s.match(/\A(amb|blu|brn|gry|grn|hzl|oth)\z/) &&
    data['pid'].to_s.match(/\A[0-9]{9}\z/)
end

passports.find_all do |passport|
  parsed = Hash[*passport.split(/\s/).flat_map {|kp| kp.split(':').map(&:to_s).map(&:strip)}]
  valid?(parsed)
end.size

