# json files

## unary_sub

Samples from the issue.  
Perform subtraction.

```
./ft_turing json/unary_sub.json "111-11="
```

## error_loop

Infinite looping error pattern.  
r changes the direction in which it moves.

```
./ft_turing json/error/error_loop.json "r-----r"
```

## error_through_to_the_left

Error pattern penetrating to the left.  
Program moves to the right while passing through "r" and to the left when it hits "l".

```
./ft_turing json/error/error_through_to_the_left.json "rrrrrl"
```

## error_continue_to_right

Patterns that continue to move to the right.  

```
./ft_turing json/error/error_continue_to_right.json "s"
```

## error_complex_continue_to_right

Patterns that continue to move to the right in complex ways.  

```
./ft_turing json/error/error_complex_continue_to_right.json "s"
```

## error_no_corresponding_transitions

Pattern with no corresponding transition.  
Sample with one transition removed from unary_sub.

```
./ft_turing json/error/error_no_corresponding_transitions.json "111-11="
```

## error_read_without_required

Pattern without required elements.  
Elements name, alphabet, blank, states, initial, finals, transitions are required.

```
./ft_turing json/error/error_read_without_required.json "111-11="
```

## error_read_long_name

Long name entry patterns.

```
./ft_turing json/error/error_read_long_name.json "111-11="
```

## error_read_name_list

Pattern of list with value of key name.

```
./ft_turing json/error/error_read_name_list.json "111-11="
```

## error_read_newline_character

Pattern of new line characters coming.  
Only printable ascii characters are supported.

```
./ft_turing json/error/error_read_newline_character.json "111-11
"
```

## error_read_non_ascii

Pattern of non-ascii characters.  
Only printable ascii characters are supported.

```
./ft_turing json/error/error_read_non_ascii.json "111-11あ"
```

## error_read_escape

Escape character pattern.

```
./ft_turing json/error/error_read_escape.json "111-11\\"
```

## error_read_alphabet_same

Patterns with the same letter.

```
./ft_turing json/error/error_read_alphabet_same.json "111-11="
```

## error_read_alphabet_no_list

Pattern where the value of key alphabet is not a list.

```
./ft_turing json/error/error_read_alphabet_no_list.json "111-11="
```

## error_read_alphabet_no_single

Patterns where the alphabet list element is not a single character.

```
./ft_turing json/error/error_read_alphabet_no_single.json "111-11="
```

## error_read_alphabet_no_element

Pattern with no alphabet list element.

```
./ft_turing json/error/error_read_alphabet_no_element.json ""
```
