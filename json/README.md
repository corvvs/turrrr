# json files

## unary_sub

Samples from the issue.  
Perform subtraction.

```
./ft_turing json/unary_sub.json "111-11="
```

## error_through_to_the_left

Error pattern penetrating to the left.  
Program moves to the right while passing through "r" and to the left when it hits "l".

```
./ft_turing json/error_through_to_the_left.json "rrrrrl"
```

## error_loop

Infinite looping error pattern  
r changes the direction in which it moves.

```
./ft_turing json/error_loop.json "r-----r"
```
