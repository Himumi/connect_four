class ConnectFour
  attr_reader :current_neighbors, :board
  def initialize
    @board = create_board
  end

  def create_board
    board = {}
    ("0".."9").to_a.reverse.each do |number|
      ("A".."J").each { |letter| board["#{letter}#{number}"] = nil }
    end
    board
  end

  def add(position, player)
    @board[position] = player.symbol if @board[position].nil?
  end

  def get_input
    puts "Please input position"
    loop  do
      position = gets.chomp
      return position if valid_input?(position) && !taken?(position)
      puts "You entered wrong position!, please enter again."
    end
  end

  def convert_to_number(input)
    return nil if !valid_input?(input)
    input = input.chars


    letters = ("A".."J").to_a
    input[0] = letters.index(input[0]).to_s
    input.join
  end

  def invalid?(array)
    array.length > 3 || array.any? { |item| !item.between?("0", "9")}
  end

  def convert_to_key(input)
    input = input.chars
    return nil if invalid?(input)

    letters = ("A".."J").to_a
    input[0] = letters[input[0].to_i]
    input.join
  end

  def valid_input?(input)
    input = input.chars
    input[0].between?("A","J") && input[1].between?("0","9")
  end

  def taken?(input)
    !@board[input].nil?
  end

  def print_board
    display, letters, count = "", "  ", 9
    dashes = "   - - - - - - - - - - - - - - - - - - - -\n"
    ("A".."J").each { |letter| letters += "  #{letter} " }
    @board.each do |key, item|
      position = key.chars
      if position[0] == "A"
        first = "\n#{dashes}#{count} |   |"
        second = "\n#{dashes}#{count} | #{item} |"
        display += item.nil? ? first : second
        count -= 1
        next
      end
      display += item.nil? ? "   |" : " #{item} |"
    end
    puts display
    puts dashes
    puts letters
  end

  def direction(key, index)
    key = convert_to_number(key).chars
    a, b = key[0].to_i, key[1].to_i

    directions = [
      [a-1, b], [a-1, b+1], [a, b+1], [a+1, b+1],
      [a+1, b], [a+1, b-1], [a, b-1], [a-1, b-1]
    ]

    convert_to_key(directions[index].join)
  end

  def update_neighbors(key)
    current = key

    @current_neighbors = (0..7).map do |items|
      index, stop, current_position, temp = items, false, current, []
      3.times do
        current_key = direction(current_position, index)
        invalid = stop || current_key.nil? || @board[current_key] != @board[current]
        next stop = true if invalid
        current_position = current_key
        temp << current_key
      end
      temp
    end
  end

  def node_in_edge(key)
    @current_neighbors.any? { |items| items.length.eql?(3)}
  end

  def node_in_middle(index = 7)
    current_neighbors.each_with_index.any? do |items, index|
      items.length.eql?(1) && current_neighbors[index - 4].length.eql?(2)
    end
  end

  def won?
    node_in_edge or node_in_middle
  end
end

# game = ConnectFour.new
# class Player
#   attr_reader :symbol
#   def initialize(symbol)
#     @symbol = symbol
#   end
# end

# player = Player.new("X")
# ["A0", "B0", "C0", "D0", "E0"].each do |key|
#   game.add(key, player)
# end

# game.print_board
# p game.update_neighbors("D0")
# p game.direction("A0", 4)
