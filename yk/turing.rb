require "json"

TX_ER = "\e[31m"
TX_CUR = "\e[30m\e[42m"
TX_RST = "\e[0m"

N = 30
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

def get_width(name)
  len = name.size
  [len + 4, 78].max
end

def print_name(name)
  len = name.size
  width = get_width(name)
  wr = width / 2
  wl = width - wr
  lenr = len / 2
  lenl = len - lenr
  puts "*" * (width + 2)
  puts "*" + (" " * (wl - lenl)) + name + (" " * (wr - lenr)) + "*"
  puts "*" * (width + 2)
end

def print_list(prefix, list)
  puts "#{prefix} [ #{list * ", "} ]"
end

def print_alphabet(a)
  print_list("Alphabet:", a)
end

def print_states(a)
  print_list("States :", a)
end

def print_initial(a)
  puts "Initial : #{a}"
end

def print_finals(a)
  print_list("Finals :", a)
end

def format_transition(from, to)
  d = to
  "(#{from}, #{d["read"]}) -> (#{d["to_state"]}, #{d["write"]}, #{d["action"]})"
end

def print_transitions(tras)
  tras.each{ |from, ts|
    ts.each{ |read, to|
      puts format_transition(from, to)
    }
  }
end

def format_tape(tape, head)
  (0...tape.size).reduce("[") { |s, i|
    s + (i == head ? TX_CUR + tape[i] + TX_RST : tape[i])
  } + "]"
end

def print_transition(tape, head, from, to)
  puts "#{format_tape(tape, head)} #{format_transition(from, to)}"
end

print_name(Name)
print_alphabet(Alphabet)
print_states(States)
print_initial(Initial)
print_finals(Finals)
print_transitions(Transitions)
puts ("*" * (get_width(Name) + 2))

Tape = Array.new(N, Blank)
tape_initial.chars.each_with_index{ |c,i|
  Tape[i] = c
}
tape_head = 0
state = Initial

# main loop
while (true) do
  break if Finals.include?(state)
  char = Tape[tape_head]
  ts = Transitions[state]
  fail "no transitions for #{state}??" if !ts
  t = ts[char]
  fail "no transition for #{char}??" if !t
  to_state = t["to_state"]
  write = t["write"]
  action = t["action"]
  Tape[tape_head] = write
  print_transition(Tape, tape_head, state, t)
  state = to_state
  case action
  when "LEFT";  tape_head = (tape_head - 1 + N) % N
  when "RIGHT"; tape_head = (tape_head + 1 + N) % N
  else
    fail "invalid action: #{action}??"
  end
end
