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

      it 'first value is A9' do
        first_value = board.keys.first
        expect(first_value).to eq("A9")
      end

      it 'last value is J9' do
        last_value = board.keys.last
        expect(last_value).to eq("J0")
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

  describe '#get_input' do
    context 'when user inputs valid position' do
      before do
        valid_input = "A0"
        allow(game).to receive(:gets).and_return(valid_input)
      end
      it 'stops loop and returns input' do
        error_message = "You entered wrong position!, please enter again."
        expect(game).not_to receive(:puts).with(error_message)
        game.get_input
      end
    end

    context 'when user inputs invalid position' do
      before do
        invalid_input = "L0"
        valid_input = "A0"
        allow(game).to receive(:puts).and_return("Please input position")
        allow(game).to receive(:gets).and_return(invalid_input, valid_input)
      end
      it 'shows error message for once' do
        error_message = "You entered wrong position!, please enter again."
        expect(game).to receive(:puts).with(error_message).once
        game.get_input
      end
    end
  end

  describe '#convert_to_number' do
    context 'when user inputs valid value (A0)' do

      it 'returns 00' do
        input = "A0"
        converted_input = game.convert_to_number(input)
        expect(converted_input).to eq("00")
      end
    end

    context 'when user inputs invalid value (L0)' do
      it 'returns nil' do
        input = "L0"
        converted_input = game.convert_to_number(input)
        expect(converted_input).to be_nil
      end
    end
  end

  describe '#convert_to_key' do
    context 'when input is 00 (valid input)' do
      it 'returns A0' do
        input = "00"
        converted_input = game.convert_to_key(input)
        expect(converted_input).to eq("A0")
      end
    end

    context 'when input is -10 (invalid input)' do
      it 'returns nil' do
        input = "-10"
        converted_input = game.convert_to_key(input)
        expect(converted_input).to be_nil
      end

    end
  end

  describe '#direction' do
    let(:player) { double('Player', symbol: "X") }
    let(:enemy) { double('Player', symbol: "O") }
    let(:neighbors) { ["B0", "B1", "C1", "D1", "D0",] }
    context 'when current position is C0' do
      before do
        position = "C0"
        neighbors.each do |neighbor|
          game.add(neighbor, player)
        end
        game.add(position, player)
      end
      it 'has C1' do
        board = game.instance_variable_get(:@board)
        c1 = board["C1"]
        expect(c1).to eq(player.symbol)
      end

      it 'has 5 neighbors, when close border' do
        board = game.instance_variable_get(:@board)
        all_five = neighbors.all? { |key| board[key] == "X"}
        expect(all_five).to eq(true)
        end
      context 'when B0 owned by other' do
        let(:neighbors) { ["B1", "C1", "D1", "D0",] }
        before do
          position = "C0"
          neighbors.each do |neighbor|
            game.add(neighbor, player)
          end
          game.add(position, player)
          game.add("B0", enemy)
        end
        it 'has not B0' do
          board = game.instance_variable_get(:@board)
          b0 = board["B0"]
          expect(b0).not_to eq(player.symbol)
        end

        it 'has 4 neighbors' do
          board = game.instance_variable_get(:@board)
          all_four = neighbors.all? { |key| board[key] == player.symbol }
          expect(all_four).to eq(true)
        end
      end
    end
  end

  describe 'update_neighbors' do
    let(:player) { double('Player', symbol: "X") }
    let(:enemy) { double('Player', symbol: "O") }
    describe 'update from D0' do
      context 'when A0, B0, C0 is allies and F0 is enemy' do
        before do
          neighbors = ["A0", "B0", "C0", "D0", "E0"]
          neighbors.each { |key| game.add(key, player) }
          game.add("F0", enemy)
          game.update_neighbors("D0")
        end
        it 'has 3 neighbors at left direction' do
          valid_neighbors = game.instance_variable_get(:@current_neighbors)
          left_neighbors = valid_neighbors[0].length
          expect(left_neighbors).to eq(3)
        end

        it 'has 1 neighbor at right direction' do
          valid_neighbors = game.instance_variable_get(:@current_neighbors)
          right_neighbors = valid_neighbors[4].length
          expect(right_neighbors).to eq(1)
        end

        it 'returns 0 for above direction' do
          valid_neighbors = game.instance_variable_get(:@current_neighbors)
          above_neighbors = valid_neighbors[2].length
          expect(above_neighbors).to eq(0)
        end

        it 'returns 0 for below direction' do
          valid_neighbors = game.instance_variable_get(:@current_neighbors)
          below_neighbors = valid_neighbors[6].length
          expect(below_neighbors).to eq(0)
        end
      end
    end
  end

  describe '#node_in_edge' do
    let(:player) { double('Player', symbol: "X") }
    let(:enemy) { double('Player', symbol: "O") }
    context 'when last node in edge (E0)' do
      context 'when left sides all are connected' do
        before do
          ["B0", "C0", "D0", "E0"].each { |key| game.add(key, player) }
          game.update_neighbors("E0")
        end
        it 'returns true' do
          all_connected = game.node_in_edge("E0")
          expect(all_connected).to be true
        end
      end

      context 'when above sides all are connected' do
        before do
          ["E3", "E2", "E1", "E0"].each { |key| game.add(key, player) }
          game.update_neighbors("E0")
        end
        it 'returns true' do
          all_connected = game.node_in_edge("E0")
          expect(all_connected).to be true
        end
      end

      context 'when diagonal sides all are connected' do
        before do
          ["C1", "B2", "A3", "D0"].each { |key| game.add(key, player) }
          game.update_neighbors("D0")
        end
        it 'returns true' do
          all_connected = game.node_in_edge("D0")
          expect(all_connected).to be true
        end
      end

      context 'when left sides all are not connected' do
        before do
          ["C0", "B0", "D0"].each { |key| game.add(key, player) }
          game.add("A0", enemy)
          game.update_neighbors("D0")
        end
        it 'returns false' do
          all_connected = game.node_in_edge("D0")
          # puts game.current_neighbors
          expect(all_connected).not_to be true
        end
      end
    end
  end

  describe '#node_in_middle' do
    let(:player) { double('Player', symbol: "X") }
    let(:enemy) { double('Player', symbol: "O") }

    describe 'when last added node in middle (D3)' do
      context 'when left side is  C3, and right side is E3, F3' do
        before do
          ["C3", "E3", "F3", "D3"].each { |key| game.add(key, player) }
          game.update_neighbors("D3")
        end
        it 'returns true' do
          all_connected = game.node_in_middle("D3")
          expect(all_connected).to be true
        end
      end

      context 'when above side is D4, and below side is D2, D1' do
        before do
          ["D4", "D2", "D1", "D3"].each { |key| game.add(key, player) }
          game.update_neighbors("D3")
        end
        it 'returns true' do
          all_connected = game.node_in_middle("D3")
          expect(all_connected).to be true
        end
      end

      context 'when left above side is C4, and right below side is E2, F1' do
        before do
          ["C4", "E2", "F1", "D3"].each { |key| game.add(key, player) }
          game.update_neighbors("D3")
        end
        it 'returns true' do
          all_connected = game.node_in_middle("D3")
          expect(all_connected).to be true
        end
      end

      context 'when all four nodes are not connected' do
        before do
          ["C3", "E3", "D3"].each { |key| game.add(key, player) }
          game.add("F3", enemy)
          game.update_neighbors("D3")
        end
        it 'returns false' do
          all_connected = game.node_in_middle("D3")
          expect(all_connected).not_to eq(true)
        end
      end
    end
  end
end
