# Skyscraper Solver

Skyscraper Solver solves [skyscraper puzzle](https://www.conceptispuzzles.com/index.aspx?uri=puzzle/skyscrapers/techniques) using [Breadth-First Search](https://en.wikipedia.org/wiki/Breadth-first_search) and [Exhaustive Search Algorithm](https://en.wikipedia.org/?title=Exhaustive_search&redirect=no).

Breadth-First Search algorithm is implemented inside [`process`](/lib/board.rb#L15) function using queue.

Exhaustive Search Algorithm is implemented inside [`exhaustive_scan`](/lib/board.rb#L39) function using recursion.

## Prerequisite

1. Ruby 3.1.2
2. Bundler 2.3.20

## Install dependencies

```bash
bundle install
bundle binstub --all
```

## How to build

TBD

## How to use

### Input Output Format

This program receives clues in an array of `size` * 4 items. The clues are in the array around the clock. This program outputs the solution in an array of `size` * `size` items to `stdout`. For more detailed explanation read [this codewars kata article](https://www.codewars.com/kata/5679d5a3f2272011d700000d/).

### Run the program

```bash
main.rb <input_file.txt>
```

for example:

```bash
ruby main.rb input/4x4.sample.txt
ruby main.rb input/6x6.sample.txt
```

### Sample Input Output

`4x4.sample.txt`

```text
4
4 3 2 1 1 2 2 2 2 2 2 1 1 2 3 4
```

`4x4.sample.txt` output

```text
1 2 3 4
2 3 4 1
3 4 1 2
4 1 2 3
Solved in 1 iteration(s)
```

---

`6x6.sample.txt`

```text
6
0 0 0 2 2 0 0 0 0 6 3 0 0 4 0 0 0 0 4 4 0 3 2 2
```

`6x6.sample.txt` output

```text
5 6 1 4 3 2
4 1 3 2 6 5
2 3 6 1 5 4
6 5 4 3 2 1
1 2 5 6 4 3
3 4 2 5 1 6
Solved in 3 iteration(s)
```

## How to test

This program has 100% test coverage, which you can check by running:

```bash
bin/rspec
open coverage/index.html
```

## How to lint

You need to install dependencies first, then run this:
```bash
bin/rubocop lib spec -A
```

## Contributors

* [Jonathan Yudi Gunawan](https://github.com/JonathanGun)
