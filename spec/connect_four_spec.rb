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
end
