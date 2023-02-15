import json
from collections import OrderedDict
import graphviz
import itertools

# file_name = '../../json/unary_add.json'
# file_name = '../../json/unary_sub.json'
# file_name = '../../json/palindrome.json'
file_name = '../../json/zero_one.json'

with open(file_name) as f:
    d = json.load(f, object_pairs_hook=OrderedDict)

print(d)

alphabet = d['alphabet']
states = d['states']
initial = d['initial']


g = graphviz.Digraph(format='png')

for node in states:
    if initial == node:
        g.node(node, shape='doublecircle')
    else:
        g.node(node)

transitions = d['transitions']
for state in states:
    if state not in transitions:
        continue
    for rule in transitions[state]:
        read_rule = rule['read']
        to_state = rule['to_state']
        write_rule = rule['write']
        action = rule['action']

        label = read_rule + '/' + write_rule + (',R' if action == 'RIGHT' else ',L')

        g.edge(state, to_state, label=label)


g.render('transition')
