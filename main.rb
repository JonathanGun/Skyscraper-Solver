require_relative 'lib/board'

size, *clues = File.read(ARGV[0]).split.map(&:to_i)
Board.new(
  size,
  top_clue: clues[0...size],
  right_clue: clues[size...size * 2],
  bottom_clue: clues[size * 2...size * 3].reverse,
  left_clue: clues[size * 3...size * 4].reverse
).process
