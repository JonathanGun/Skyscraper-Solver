require 'board'

describe Board do
  context 'board clue "1"' do
    it 'should solve the nearest cell from the clue' do
      board = Board.new(4, top_clue: [1, 0, 0, 0])
      board.process(1)

      expect(board.cells[0][0]).to eq Set.new([4])
    end
  end

  context 'board clue equals to its size' do
    context 'as a top clue' do
      it 'should solve the column with that clue' do
        board = Board.new(4, top_clue: [4, 0, 0, 0])
        board.process(1)

        expect(board.cells[0][0]).to eq Set.new([1])
        expect(board.cells[1][0]).to eq Set.new([2])
        expect(board.cells[2][0]).to eq Set.new([3])
        expect(board.cells[3][0]).to eq Set.new([4])
      end
    end

    context 'as a left clue' do
      it 'should solve the row with that clue' do
        board = Board.new(4, left_clue: [4, 0, 0, 0])
        board.process(1)

        expect(board.cells[0][0]).to eq Set.new([1])
        expect(board.cells[0][1]).to eq Set.new([2])
        expect(board.cells[0][2]).to eq Set.new([3])
        expect(board.cells[0][3]).to eq Set.new([4])
      end
    end

    context 'as a bottom clue' do
      it 'should solve the column with that clue' do
        board = Board.new(4, bottom_clue: [4, 0, 0, 0])
        board.process(1)

        expect(board.cells[3][0]).to eq Set.new([1])
        expect(board.cells[2][0]).to eq Set.new([2])
        expect(board.cells[1][0]).to eq Set.new([3])
        expect(board.cells[0][0]).to eq Set.new([4])
      end
    end

    context 'as a right clue' do
      it 'should solve the row with that clue' do
        board = Board.new(4, right_clue: [4, 0, 0, 0])
        board.process(1)

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
        board = Board.new(4, top_clue: [4, 0, 0, 0], left_clue: [4, 0, 0, 0])
        board.process(1)

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
          board = Board.new(4, top_clue: [4, 0, 0, 0], left_clue: [1, 0, 0, 0])
          expect do
            board.process(1)
          end.to raise_error(RuntimeError)
        end
      end
    end
  end

  describe '#exhaustive_scan' do
    context 'board with size 3' do
      describe 'with clue "2" on top' do
        it 'should not include 3 on the first cell and 1 on the second cell' do
          board = Board.new(3, top_clue: [2, 0, 0])
          board.process(1)

          expect(board.cells[0][0]).to eq Set.new([1, 2])
          expect(board.cells[1][0]).to eq Set.new([1, 3])
          expect(board.cells[2][0]).to eq Set.new([1, 2, 3])
        end
      end

      describe 'with clue "2" on left' do
        it 'should not include 3 on the first cell and 1 on the second cell' do
          board = Board.new(3, left_clue: [2, 0, 0])
          board.process(1)

          expect(board.cells[0][0]).to eq Set.new([1, 2])
          expect(board.cells[0][1]).to eq Set.new([1, 3])
          expect(board.cells[0][2]).to eq Set.new([1, 2, 3])
        end
      end
    end

    context 'board with size 4' do
      describe 'with clue "2" on top' do
        it 'should not include 4 on the first cell' do
          board = Board.new(4, top_clue: [2, 0, 0, 0])
          board.process(1)

          expect(board.cells[0][0]).to eq Set.new([1, 2, 3])
          expect(board.cells[1][0]).to eq Set.new([1, 2, 4])
          expect(board.cells[2][0]).to eq Set.new([1, 2, 3, 4])
          expect(board.cells[3][0]).to eq Set.new([1, 2, 3, 4])
        end
      end

      describe 'with clue "3" on top' do
        it 'should not include 3 and 4 on the first cell and 4 on the second cell' do
          board = Board.new(4, top_clue: [3, 0, 0, 0])
          board.process(1)

          expect(board.cells[0][0]).to eq Set.new([1, 2])
          expect(board.cells[1][0]).to eq Set.new([1, 2, 3])
          expect(board.cells[2][0]).to eq Set.new([1, 2, 3, 4])
          expect(board.cells[3][0]).to eq Set.new([1, 2, 3, 4])
        end
      end
    end
  end

  context 'example from internet' do
    context '4x4' do
      it 'should be able to solve' do
        board = Board.new(
          4,
          top_clue: [4, 3, 2, 1],
          left_clue: [4, 3, 2, 1],
          bottom_clue: [1, 2, 2, 2],
          right_clue: [1, 2, 2, 2]
        )
        board.process(2)
      end
    end

    context '5x5' do
      it 'should be able to solve' do
        board = Board.new(
          5,
          top_clue: [0, 0, 2, 1, 0],
          left_clue: [4, 4, 0, 0, 0],
          bottom_clue: [2, 0, 1, 0, 0],
          right_clue: [0, 0, 5, 0, 0]
        )
        board.process(10)
      end
    end

    context '6x6' do
      it 'should be able to solve' do
        board = Board.new(
          6,
          top_clue: [0, 0, 0, 2, 2, 0],
          left_clue: [2, 2, 3, 0, 4, 4],
          bottom_clue: [0, 0, 0, 0, 4, 0],
          right_clue: [0, 0, 0, 6, 3, 0]
        )
        board.process(10)
      end
    end

    context '5x5' do
      it 'should be able to solve' do
        board = Board.new(
          5,
          top_clue: [0, 2, 0, 0, 0],
          left_clue: [4, 3, 0, 0, 0],
          bottom_clue: [0, 0, 0, 2, 0],
          right_clue: [0, 0, 0, 3, 5]
        )
        board.process(10)
      end
    end

    context '6x6' do
      it 'should be able to solve' do
        board = Board.new(
          6,
          top_clue: [0, 4, 0, 0, 0, 0],
          left_clue: [3, 0, 4, 0, 5, 0],
          bottom_clue: [3, 0, 4, 0, 3, 0],
          right_clue: [0, 3, 0, 2, 0, 0]
        )
        board.process(10)
      end
    end

    context '6x6' do
      it 'should be able to solve' do
        board = Board.new(
          6,
          top_clue: [3, 0, 3, 0, 3, 0],
          left_clue: [0, 0, 6, 0, 0, 0],
          bottom_clue: [0, 4, 0, 4, 0, 4],
          right_clue: [0, 0, 0, 4, 0, 0]
        )
        board.process(100)
      end
    end
  end
end
