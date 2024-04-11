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
end
