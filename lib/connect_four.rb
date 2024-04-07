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
    display, letters = "", ""
    (0..9).each do |letter|
      letters += "  #{letter} "
    end
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

game = ConnectFour.new
game.print_board
