require './lib/connect_four'

describe ConnectFour do
  let(:first_player) { double('Player', symbol: "X", name: "foo") }
  let(:last_player) { double('Player', symbol: "O", name: "him") }
  subject(:game) { described_class.new(first_player, last_player) }
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
    context 'when position is nil' do

      before do
        game.add("A0", first_player)
      end

      it 'adds to the position' do
        board = game.instance_variable_get(:@board)
        expect(board["A0"]).to eq(first_player.symbol)
      end
    end

    context 'when position is not nil' do

      before do
        game.add("A0", first_player)
        game.add("A0", last_player)
      end

      it 'does not change value' do
        board = game.instance_variable_get(:@board)
        expect(board["A0"]).not_to eq(last_player.symbol)
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

    context 'when position is not taken' do
      it 'returns false' do
        check_position = game.taken?(position)
        expect(check_position).to eq(false)
      end
    end

    context 'when position is taken' do

      before do
        game.add(position, first_player)
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
    context 'when current position is C0' do
      let(:neighbors) { ["B0", "B1", "C1", "D1", "D0"] }

      before do
        last_position = "C0"
        neighbors.each { |neighbor| game.add(neighbor, first_player) }
        game.add(last_position, first_player)
      end

      it 'has C1' do
        board = game.instance_variable_get(:@board)
        c1 = board["C1"]
        expect(c1).to eq(first_player.symbol)
      end

      it 'has 5 neighbors, when close border' do
        board = game.instance_variable_get(:@board)
        all_five = neighbors.all? { |key| board[key] == first_player.symbol }
        expect(all_five).to eq(true)
      end

      context 'when B0 owned by other' do
        let(:neighbors) { ["B1", "C1", "D1", "D0"] }

        before do
          last_position = "C0"
          neighbors.each { |neighbor| game.add(neighbor, first_player) }
          game.add(last_position, first_player)
          game.add("B0", last_player)
        end

        it 'has not B0' do
          board = game.instance_variable_get(:@board)
          b0 = board["B0"]
          expect(b0).not_to eq(first_player.symbol)
        end

        it 'has 4 neighbors' do
          board = game.instance_variable_get(:@board)
          all_four = neighbors.all? { |key| board[key] == first_player.symbol }
          expect(all_four).to eq(true)
        end
      end
    end
  end

  describe '#update_neighbors' do
    describe 'update from D0' do
      context 'when A0, B0, C0 is allies and F0 is enemy' do

        before do
          neighbors = ["A0", "B0", "C0", "D0", "E0"]
          neighbors.each { |key| game.add(key, first_player) }
          game.add("F0", last_player)
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
    context 'when last node in edge (E0)' do
      context 'when left sides all are connected' do

        before do
          ["B0", "C0", "D0", "E0"].each { |key| game.add(key, first_player) }
          game.update_neighbors("E0")
        end

        it 'returns true' do
          all_connected = game.node_in_edge
          expect(all_connected).to be true
        end
      end

      context 'when above sides all are connected' do

        before do
          ["E3", "E2", "E1", "E0"].each { |key| game.add(key, first_player) }
          game.update_neighbors("E0")
        end

        it 'returns true' do
          all_connected = game.node_in_edge
          expect(all_connected).to be true
        end
      end

      context 'when diagonal sides all are connected' do

        before do
          ["C1", "B2", "A3", "D0"].each { |key| game.add(key, first_player) }
          game.update_neighbors("D0")
        end

        it 'returns true' do
          all_connected = game.node_in_edge
          expect(all_connected).to be true
        end
      end

      context 'when left sides all are not connected' do

        before do
          ["C0", "B0", "D0"].each { |key| game.add(key, first_player) }
          game.add("A0", last_player)
          game.update_neighbors("D0")
        end

        it 'returns false' do
          all_connected = game.node_in_edge
          expect(all_connected).not_to be true
        end
      end
    end
  end

  describe '#node_in_middle' do
    describe 'when last added node in middle is (D3)' do
      context 'when left side is  C3, and right side is E3, F3' do

        before do
          ["C3", "E3", "F3", "D3"].each { |key| game.add(key, first_player) }
          game.update_neighbors("D3")
        end

        it 'returns true' do
          all_connected = game.node_in_middle
          expect(all_connected).to be true
        end
      end

      context 'when above side is D4, and below side is D2, D1' do

        before do
          ["D4", "D2", "D1", "D3"].each { |key| game.add(key, first_player) }
          game.update_neighbors("D3")
        end

        it 'returns true' do
          all_connected = game.node_in_middle
          expect(all_connected).to be true
        end
      end

      context 'when left above side is C4, and right below side is E2, F1' do

        before do
          ["C4", "E2", "F1", "D3"].each { |key| game.add(key, first_player) }
          game.update_neighbors("D3")
        end

        it 'returns true' do
          all_connected = game.node_in_middle
          expect(all_connected).to be true
        end
      end

      context 'when all four nodes are not connected' do

        before do
          ["C3", "E3", "D3"].each { |key| game.add(key, first_player) }
          game.add("F3", last_player)
          game.update_neighbors("D3")
        end

        it 'returns false' do
          all_connected = game.node_in_middle
          expect(all_connected).not_to eq(true)
        end
      end
    end
  end

  describe '#draw?' do
  let(:player) { double('Player', symbol: "X") }
    context 'when board full without winner' do
      before do
        keys = game.board.keys
        keys.each { |key| game.add(key, player) }
      end
      it 'retuns true' do
        draw = game.draw?
        expect(draw).to eq(true)
      end
    end
  end

  describe '#switch_player' do
    context 'when round count is odd number' do
      before do
        odd = 5
        game.switch_player(odd)
      end
      it 'returns first_player as current player' do
        curr_player = game.instance_variable_get(:@current_player)
        expect(curr_player.symbol).to eq("X")
      end
    end

    context 'when round count is even number' do
      before do
        even = 8
        game.switch_player(even)
      end
      it 'returns last_player as current player' do
        curr_player = game.instance_variable_get(:@current_player)
        expect(curr_player.symbol).to eq("O")
      end
    end
  end

  describe '#over?' do
    context 'when one of coditional returns true' do
      before do
        allow(game).to receive(:won?).and_return(true)
        allow(game).to receive(:draw?).and_return(false)
      end
      it 'returns true, if #won? returns true' do
        game_over = game.over?
        expect(game_over).to be true
      end

      before do
        allow(game).to receive(:won?).and_return(false)
        allow(game).to receive(:draw?).and_return(true)
      end
      it 'returns true, if #draw? returns true' do
        game_over = game.over?
        expect(game_over).to be true
      end
    end

    context 'when both conditionals are false' do
      before do
        allow(game).to receive(:won?).and_return(false)
        allow(game).to receive(:draw?).and_return(false)
      end
      it 'returns false' do
        game_over = game.over?
        expect(game_over).not_to be true
      end
    end
  end

  describe '#turn_player' do
    context 'check looping in method' do
      before(:each) do
        allow(game).to receive(:puts).with("Please input position")
        allow(game).to receive(:gets).and_return("D5", "F4")
        allow(game).to receive(:add)
        allow(game).to receive(:print_board)
        allow(game).to receive(:update_neighbors)
      end
      it 'should stop loop, when conditions are fulfilled' do
        allow(game).to receive(:over?).and_return(true)
        expect{ game.turn_player }.not_to change{ game.round }.from(1)
      end

      it 'will ask input again, when conditions are not fulfilled' do
        allow(game).to receive(:over?).and_return(false, true)
        expect{ game.turn_player }.to change{ game.round }.from(1).to(2)
      end
    end
  end
end
