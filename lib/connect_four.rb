class ConnectFour
  def initialize
    @board = create_board
  end

  def create_board
    board = {}
    ("A".."J").each do |letter|
      ("0".."9").each { |number| board["#{letter}#{number}"] = nil }
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

  def valid_input?(input)
    input = input.chars
    input[0].between?("A","J") && input[1].between?("0","9")
  end

  def taken?(input)
    !@board[input].nil?
  end

  def print_board
    display, letters = "", ""
    (0..9).each { |letter| letters += "  #{letter} " }
    puts " - - - - - - - - - - - - - - - - - - - -"
    @board.each do |key, item|
      position = key.chars
      if position[1] == "9"
        display += "|   | #{position[0]}\n - - - - - - - - - - - - - - - - - - - -\n" if item.nil?
        display += "| #{item} | #{position[0]}\n - - - - - - - - - - - - - - - - - - - -\n" unless item.nil?
        next
      end
      display += "|   " if item.nil?
      display += "| #{item} " unless item.nil?
    end
    puts display
    puts letters
  end
end

# game = ConnectFour.new
# game.print_board
