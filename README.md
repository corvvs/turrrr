# ft_turing

```
> ./ft_turing json/unary_add.json "111+11="
********************************************************************************
*                                  unary_add                                   *
********************************************************************************
Alphabet: [1, ., +, =]
States: [scanright, eraseone, HALT]
Initial: scanright
Finals: [HALT]
(eraseone, 1) -> (HALT, ., RIGHT)
(scanright, 1) -> (scanright, 1, RIGHT)
(scanright, +) -> (scanright, 1, RIGHT)
(scanright, =) -> (eraseone, ., LEFT)
********************************************************************************
[111+11=.................................] (scanright, 1) -> (scanright, 1, RIGHT)
[111+11=.................................] (scanright, 1) -> (scanright, 1, RIGHT)
[111+11=.................................] (scanright, 1) -> (scanright, 1, RIGHT)
[111+11=.................................] (scanright, +) -> (scanright, 1, RIGHT)
[111111=.................................] (scanright, 1) -> (scanright, 1, RIGHT)
[111111=.................................] (scanright, 1) -> (scanright, 1, RIGHT)
[111111=.................................] (scanright, =) -> (eraseone, ., LEFT)
[111111..................................] (eraseone, 1) -> (HALT, ., RIGHT)
[11111...................................]
done. O(n log n)
```

## Overview

This is a 42 assignment to create a Turing machine defined in a json file and its simulator.

## Requirement

- opam


## Usage

```
git clone .....
cd turrrr
make
```

Then, please refer to the contents of [json/README.md](https://github.com/corvvs/turrrr/tree/master/json) and execute it.

## Features

```
> ./ft_turing
usage: ./ft_turing [JSON definition file] [tape]
```

- You can simulate a Turing machine by passing a Turing machine defined in a json file and a tape.
- Time complexity can be calculated. (It's a simple algorithm.)


## Author

- [yokawada](https://github.com/corvvs)
- [ksuzuki (kota)](https://twitter.com/Kotabrog)
