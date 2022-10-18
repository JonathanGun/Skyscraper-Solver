require 'board'

describe Board do
  context 'board clue "1"' do
    it 'should solve the nearest cell from the clue' do
      board = Board.new(4, top_clue: [1, nil, nil, nil])
      board.queue_length.times { board.step }

      expect(board.cells[0][0]).to eq Set.new([4])
    end
  end

  context 'board clue equals to its size' do
    context 'as a top clue' do
      it 'should solve the column with that clue' do
        board = Board.new(4, top_clue: [4, nil, nil, nil])
        board.queue_length.times { board.step }

        expect(board.cells[0][0]).to eq Set.new([1])
        expect(board.cells[1][0]).to eq Set.new([2])
        expect(board.cells[2][0]).to eq Set.new([3])
        expect(board.cells[3][0]).to eq Set.new([4])
      end
    end

    context 'as a left clue' do
      it 'should solve the row with that clue' do
        board = Board.new(4, left_clue: [4, nil, nil, nil])
        board.queue_length.times { board.step }

        expect(board.cells[0][0]).to eq Set.new([1])
        expect(board.cells[0][1]).to eq Set.new([2])
        expect(board.cells[0][2]).to eq Set.new([3])
        expect(board.cells[0][3]).to eq Set.new([4])
      end
    end

    context 'as a bottom clue' do
      it 'should solve the column with that clue' do
        board = Board.new(4, bottom_clue: [4, nil, nil, nil])
        board.queue_length.times { board.step }

        expect(board.cells[3][0]).to eq Set.new([1])
        expect(board.cells[2][0]).to eq Set.new([2])
        expect(board.cells[1][0]).to eq Set.new([3])
        expect(board.cells[0][0]).to eq Set.new([4])
      end
    end

    context 'as a right clue' do
      it 'should solve the row with that clue' do
        board = Board.new(4, right_clue: [4, nil, nil, nil])
        board.queue_length.times { board.step }

        expect(board.cells[0][3]).to eq Set.new([1])
        expect(board.cells[0][2]).to eq Set.new([2])
        expect(board.cells[0][1]).to eq Set.new([3])
        expect(board.cells[0][0]).to eq Set.new([4])
      end
    end
  end

  context 'board with 2 clues' do
    context 'in top and left' do
      it 'should solve the row and column with those clues' do
        board = Board.new(4, top_clue: [4, nil, nil, nil], left_clue: [4, nil, nil, nil])
        board.queue_length.times { board.step }

        expect(board.cells[0][0]).to eq Set.new([1])
        expect(board.cells[1][0]).to eq Set.new([2])
        expect(board.cells[2][0]).to eq Set.new([3])
        expect(board.cells[3][0]).to eq Set.new([4])
        expect(board.cells[0][1]).to eq Set.new([2])
        expect(board.cells[0][2]).to eq Set.new([3])
        expect(board.cells[0][3]).to eq Set.new([4])
      end

      describe 'but it has conflicting clues' do
        it 'should raise error' do
          board = Board.new(4, top_clue: [4, nil, nil, nil], left_clue: [1, nil, nil, nil])
          expect do
            board.queue_length.times { board.step }
          end.to raise_error(RuntimeError)
        end
      end
    end
  end
end
