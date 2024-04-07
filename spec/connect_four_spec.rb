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
end
