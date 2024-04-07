require './lib/node'

describe Node do
  describe 'initialize' do
    context 'when make new node' do
      let(:player) { double('player', symbol: 'x') }
      it 'takes player symbol' do
        node = Node.new(player)
        expect(node.symbol).to eq(player.symbol)
      end
    end
  end
end
