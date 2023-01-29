require "json"
N = 100
json_name, tape_initial = ARGV

Definition = JSON.parse(File.read(json_name))
Name = Definition["name"]
Alphabet = Definition["alphabet"]
Blank = Definition["blank"]
States = Definition["states"]
Initial = Definition["initial"]
Finals = Definition["finals"]
Transitions = Hash[Definition["transitions"].map{ |k,v|
  r = {}
  v.each{ |d| r[d["read"]] = d }
  [k,r]
}]

puts "Alphabet:", Alphabet
puts "Blank:", Blank
puts "States:", States
puts "Initial:", Initial
puts "Finals:", Finals
puts "Transitions:"
p Transitions

Tape = Array.new(N, Blank)
tape_initial.chars.each_with_index{ |c,i|
  Tape[i] = c
}
tape_head = 0
state = Initial
puts "Initial Tape:", Tape * ""
# main loop
while (true) do
  break if Finals.include?(state)
  char = Tape[tape_head]
  ts = Transitions[state]
  fail "no transitions for #{state}??" if !ts
  p ts
  t = ts[char]
  fail "no transition for #{char}??" if !t
  puts "transition:", t
  to_state = t["to_state"]
  write = t["write"]
  action = t["action"]
  state = to_state
  Tape[tape_head] = write
  case action
  when "LEFT";  tape_head = (tape_head - 1 + N) % N
  when "RIGHT"; tape_head = (tape_head + 1 + N) % N
  else
    fail "invalid action: #{action}??"
  end

  puts "Char: #{char}"
  puts "Tape: #{Tape}"
  puts "Head: #{tape_head}"
  puts "State: #{state}"
  sleep 1
end

puts "done."
