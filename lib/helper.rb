def generate_valid_combinations(previous_value, clue, reverse_clue)
  return [] if clue.nil? && reverse_clue.nil?

  possible_combinations = generate_combinations(previous_value).filter do |comb|
    matches_clue?(comb, clue, reverse_clue)
  end
  raise 'No possible combination' if possible_combinations.size.zero?

  compress_combinations(possible_combinations)
end

def generate_combinations(number_set)
  return number_set[0] if number_set.size == 1

  number_set[0].map do |head|
    tail = generate_combinations(number_set[1..])
    preprocess_tail(tail, head, number_set.size).map { |v| [head, *v] }
  end.flatten(1)
end

def preprocess_tail(tail, head, valid_size)
  tail.map { |v| [*v] }.filter { _1.size + 1 == valid_size }.filter { !_1.include?(head) }
end

def compress_combinations(combinations)
  compressed = Array.new(@size) { Set.new }
  combinations.each do |combination|
    (0...@size).each do |col|
      compressed[col] << combination[col]
    end
  end
  compressed
end
