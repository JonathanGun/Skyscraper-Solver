class Board
  attr_reader :cells

  def initialize(size = 4, top_clue: nil, left_clue: nil, bottom_clue: nil, right_clue: nil)
    @size = size
    @cells = Array.new(size) { Array.new(size) { Set.new(1..size) } }
    @top_clue = top_clue || ([nil] * size)
    @left_clue = left_clue || ([nil] * size)
    @bottom_clue = bottom_clue || ([nil] * size)
    @right_clue = right_clue || ([nil] * size)
    @queue = Queue.new
    preprocess
  end

  def preprocess
    preprocess_top_clue
    preprocess_left_clue
    preprocess_bottom_clue
    preprocess_right_clue
  end

  def process
    step until @queue.empty?
  end

  def step
    row, col, value = @queue.pop
    set_cell(row, col, value)
  end

  def queue_length
    @queue.length
  end

  private

  def preprocess_top_clue
    @top_clue.each_with_index do |clue, j|
      case clue
      when 1
        @queue << [0, j, @size]
      when @size
        @size.times do |i|
          @queue << [i, j, i + 1]
        end
      end
    end
  end

  def preprocess_left_clue
    @left_clue.each_with_index do |clue, i|
      case clue
      when 1
        @queue << [i, 0, @size]
      when @size
        @size.times do |j|
          @queue << [i, j, j + 1]
        end
      end
    end
  end

  def preprocess_bottom_clue
    @bottom_clue.each_with_index do |clue, j|
      case clue
      when 1
        @queue << [@size - 1, j, @size]
      when @size
        @size.times do |i|
          @queue << [i, j, @size - i]
        end
      end
    end
  end

  def preprocess_right_clue
    @right_clue.each_with_index do |clue, i|
      case clue
      when 1
        @queue << [i, @size - 1, @size]
      when @size
        @size.times do |j|
          @queue << [i, j, @size - j]
        end
      end
    end
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
end
