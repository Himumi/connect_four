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

  def print_board
    display = ""
    puts " - - - - - - - - - - - - - - - - - - - -"
    @board.each do |key, item|
      position = key.chars
      if position[1] == "9"
        display += "|   |\n - - - - - - - - - - - - - - - - - - - -\n" if item.nil?
        display += "| #{item} |\n - - - - - - - - - - - - - - - - - - - -\n" unless item.nil?
        next
      end
      display += "|   " if item.nil?
      display += "| #{item} " unless item.nil?
    end
    puts display
  end
end

game = ConnectFour.new
game.print_board
