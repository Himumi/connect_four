require './lib/player'

describe Player do
  describe 'initialize' do
    context 'when create new player' do
      subject(:player) { described_class.new('X', 'foo') }
      it 'takes symbol and name' do
        symbol = player.instance_variable_get(:@symbol)
        name = player.instance_variable_get(:@name)
        expect(symbol && name).not_to be_nil
      end
    end
  end
end
