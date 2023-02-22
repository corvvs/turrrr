import json
from collections import OrderedDict
import pprint
import itertools


d = OrderedDict()
d['name'] = 'machine_make_machines'
d['alphabet'] = ["1", ".", " ", "+", "=", 'R', 'L', 'A', 'B', 'H', '>', '[', ']', '*']
d['blank'] = " "
d['states'] = ["first_search", "first_read", "hit", "HALT"]

p = itertools.product('ABH', '1.+=', 'RL')
pattern = [e[0] + e[1] + e[2] for e in p]

print(pattern)
print(len(pattern))

p = itertools.product('AB', '1.+=')
current = [e[0] + e[1] for e in p]

print(current)
print(len(current))

meta_state_current = ['go_start', 'search_>', 'hit_>', 'state_hit']

p = itertools.product(current, meta_state_current)
current_all_state = [e[0] + '_' + e[1] for e in p]
d['states'] += current_all_state

print(current_all_state)
print(len(current_all_state))

to_one = ['to_A', 'to_B', 'to_H']
d['states'] += to_one

print(to_one)
print(len(to_one))

p = itertools.product(to_one, '1.+=')
to_two = [e[0] + e[1] for e in p]
d['states'] += to_two

print(to_two)
print(len(to_two))

p = itertools.product(['search_'], pattern)
search_pattern = [e[0] + e[1] for e in p]
d['states'] += search_pattern

print(search_pattern)
print(len(search_pattern))

read_state = ['read_A', 'read_B']
d['states'] += read_state

print(read_state)
print(len(read_state))

d['initial'] = "first_search"
d['finals'] = ["HALT"]
d['transitions'] = OrderedDict()

def write_blank(s):
    if s == '.':
        return ' '
    else:
        return s

def set_orderd_dict_list(read, to_state, write, action):
    return OrderedDict([('read', read), ('to_state', to_state), ('write', write), ('action', action)])

def same_all(state, read_list, direction):
    return [set_orderd_dict_list(r, state, r, direction) for r in read_list]

left_first = ['1', '.', '+', '=', 'R', 'L', 'A', 'B', 'H', '>', '[', ' ']
first_search_transitions = same_all('first_search', left_first, 'RIGHT')

print(first_search_transitions)
print(len(first_search_transitions))

d['transitions']['first_search'] = []
d['transitions']['first_search'] += first_search_transitions
d['transitions']['first_search'] += [set_orderd_dict_list(']', 'first_read', ']', 'RIGHT')]

tape = ["1", ".", "+", "="]
first_read_transitions = [set_orderd_dict_list(write_blank(t), 'A' + t + '_go_start', '*', 'LEFT') for t in tape]

print(first_read_transitions)
print(len(first_read_transitions))

d['transitions']['first_read'] = []
d['transitions']['first_read'] += first_read_transitions

for current_one in current:
    state = current_one + '_go_start'
    d['transitions'][state] = same_all(state, ["1", ".", " ", "+", "=", 'R', 'L', 'A', 'B', 'H', '>', ']'], 'LEFT')
    d['transitions'][state] += [set_orderd_dict_list('[', current_one + '_search_>', '[', 'RIGHT')]

for current_one in current:
    state = current_one + '_search_>'
    d['transitions'][state] = same_all(state, ["1", ".", " ", "+", "=", 'R', 'L', 'A', 'B', 'H'], 'RIGHT')
    d['transitions'][state] += [set_orderd_dict_list('>', current_one + '_hit_>', '>', 'RIGHT')]

for current_one in current:
    state = current_one + '_hit_>'
    read_list = ['A', 'B', 'H']
    read_list.remove(current_one[0])
    d['transitions'][state] = same_all(current_one + '_search_>', read_list, 'RIGHT')
    d['transitions'][state] += [set_orderd_dict_list(current_one[0], current_one + '_state_hit', current_one[0], 'RIGHT')]

for current_one in current:
    state = current_one + '_state_hit'
    read_list = ["1", ".", "+", "="]
    read_list.remove(current_one[1])
    d['transitions'][state] = same_all(current_one + '_search_>', read_list, 'RIGHT')
    d['transitions'][state] += [set_orderd_dict_list(current_one[1], 'hit', current_one[1], 'RIGHT')]

d['transitions']['hit'] = [
    set_orderd_dict_list(s, 'to_' + s, s, 'RIGHT')
        for s in ['A', 'B', 'H']
]

for s in ['A', 'B', 'H']:
    state = 'to_' + s
    d['transitions'][state] = [
        set_orderd_dict_list(a, state + a, a, 'RIGHT')
            for a in ['1', '.', '+', '=']
    ]

p = itertools.product(['A', 'B', 'H'], ['1', '.', '+', '='])
state_and_alphabet = [e[0] + e[1] for e in p]

for sa in state_and_alphabet:
    state = 'to_' + sa
    d['transitions'][state] = [
        set_orderd_dict_list(a, 'search_' + sa + a, a, 'RIGHT')
            for a in ['R', 'L']
    ]

for p in search_pattern:
    d['transitions'][p] = same_all(p, ["1", ".", " ", "+", "=", 'R', 'L', 'A', 'B', 'H', '>', ']'], 'RIGHT')
    if p[7] == 'A':
        state = 'read_A'
    elif p[7] == 'B':
        state = 'read_B'
    else:
        state = 'HALT'
    direction = 'RIGHT' if p[9] == 'R' else 'LEFT'
    d['transitions'][p] += [set_orderd_dict_list('*', state, write_blank(p[8]), direction)]

for p in ['A', 'B']:
    state = 'read_' + p
    read_list = ['1', '.', '+', '=']
    d['transitions'][state] = [
        set_orderd_dict_list(write_blank(r), p + r + '_go_start', '*', 'LEFT')
            for r in read_list
    ]


with open('machine_make_machines.json', 'w') as f:
    json.dump(d, f, indent=4)
