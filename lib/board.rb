require_relative 'helper'
require 'set'

class Board
  attr_reader :cells

  def initialize(size = 4, top_clue: nil, left_clue: nil, bottom_clue: nil, right_clue: nil)
    @size = size
    @cells = Array.new(size) { Array.new(size) { Set.new(1..size) } }
    @top_clue = top_clue || Array.new(size) { 0 }
    @left_clue = left_clue || Array.new(size) { 0 }
    @bottom_clue = bottom_clue || Array.new(size) { 0 }
    @right_clue = right_clue || Array.new(size) { 0 }
  end

  def process(max_iter = 1000)
    count = 0
    @queue = Queue.new
    until solved? || count >= max_iter
      exhaustive_scan
      step until @queue.empty?
      count += 1
    end
    puts to_s
    puts "#{solved? ? 'Solved' : 'Failed to solve'} in #{count} iteration(s)"
  end

  private

  def to_s
    output = @cells
    output = output.map { |row| row.map(&:first) } if solved?
    "#{output.map { |row| row.join(' ') }.join("\n")}\n"
  end

  def solved?
    @cells.all? { |row| row.all? { |cell| cell.length == 1 } }
  end

  def exhaustive_scan
    @size.times { |i| bruteforce_row(i) }
    @size.times { |j| bruteforce_col(j) }
  end

  def step
    row, col, value = @queue.pop
    set_cell(row, col, value)
  end

  def set_cell(row, col, value)
    raise "Invalid value #{value} for cell (#{row}, #{col})" unless @cells[row][col].include?(value)

    @cells[row][col] = Set.new([value])
    eliminate_value_from_whole_row_and_col(row, col, value)
  end

  def eliminate_value_from_whole_row_and_col(row, col, value)
    @cells[row].each_with_index do |cell, j|
      eliminate_value_from_cell(row, j, value) if j != col && cell.include?(value)
    end
    @cells.each_with_index do |r, i|
      eliminate_value_from_cell(i, col, value) if i != row && r[col].include?(value)
    end
  end

  def eliminate_value_from_cell(row, col, value)
    return unless @cells[row][col].include?(value)

    raise "Failed to eliminate value #{value} from cell (#{row}, #{col})" if @cells[row][col].size == 1

    @cells[row][col].delete(value)
    @queue << [row, col, @cells[row][col].first] if @cells[row][col].size == 1
  end

  def bruteforce_row(row)
    previous_value = @cells[row]
    valid_combinations = generate_valid_combinations(previous_value, @left_clue[row], @right_clue[row])
    update_possible_combination_on_row(valid_combinations, row)
  end

  def bruteforce_col(col)
    previous_value = @cells.map { |row| row[col] }
    valid_combinations = generate_valid_combinations(previous_value, @top_clue[col], @bottom_clue[col])
    update_possible_combination_on_col(valid_combinations, col)
  end

  def update_possible_combination_on_row(updated_value, row)
    updated_value.each_with_index do |cell, col|
      @cells[row][col] = cell
      @queue << [row, col, cell.first] if cell.size == 1
    end
  end

  def update_possible_combination_on_col(updated_value, col)
    updated_value.each_with_index do |cell, row|
      @cells[row][col] = cell
      @queue << [row, col, cell.first] if cell.size == 1
    end
  end

  def matches_clue?(combination, clue, reverse_clue)
    (clue.zero? || count_visible_building(combination) == clue) &&
      (reverse_clue.zero? || count_visible_building(combination.reverse) == reverse_clue)
  end

  def count_visible_building(heights)
    current_height = 0
    heights.sum do |height|
      if height > current_height
        current_height = height
        1
      else
        0
      end
    end
  end
end
