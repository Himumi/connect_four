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
end

# game = ConnectFour.new
# game.print_board
# p game.board["A0"]
