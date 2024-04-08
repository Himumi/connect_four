require './lib/connect_four'

describe ConnectFour do
  subject(:game) { described_class.new() }
  describe '#create_board' do
    context 'when initialize class automatically create board' do
      let(:board) { game.instance_variable_get(:@board) }
      it 'has 100 length' do
        board_length = board.length
        expect(board_length).to be 100
      end

      it 'first value is A0' do
        first_value = board.keys.first
        expect(first_value).to eq("A0")
      end

      it 'last value is J9' do
        last_value = board.keys.last
        expect(last_value).to eq("J9")
      end
    end
  end

  describe '#add' do
    let(:player_1) { double('player', symbol: "X", name: "foo") }
    let(:player_2) { double('player', symbol: "O", name: "roo") }
    context 'when position is nil' do
      before do
        game.add("A0", player_1)
      end
      it 'adds to the position' do
        board = game.instance_variable_get(:@board)
        expect(board["A0"]).to  eq(player_1.symbol)
      end
    end

    context 'when position is not nil' do
      before do
        game.add("A0", player_1)
        game.add("A0", player_2)
      end
      it 'does not change value' do
        board = game.instance_variable_get(:@board)
        expect(board["A0"]).not_to eq(player_2.symbol)
      end
    end
  end

  describe '#valid_input?' do
    context 'when user input value' do
      it 'returns true if input is between A0..J9' do
        input = "A0"
        check_input = game.valid_input?(input)
        expect(check_input).to eq(true)
      end

      it 'returns false if input is not between A0..J9' do
        input = "L0"
        check_input = game.valid_input?(input)
        expect(check_input).not_to eq(true)
      end
    end
  end

  describe '#taken?' do
    let(:position) { "A0" }
    let(:player) { double('Player', symbol: "X") }

    context 'when position is not taken' do
      it 'returns false' do
        check_position = game.taken?(position)
        expect(check_position).to eq(false)
      end
    end

    context 'when position is taken' do
      before do
        game.add(position, player)
      end
      it 'returns true' do
        check_position = game.taken?(position)
        expect(check_position).to eq(true)
      end
    end
  end
end
