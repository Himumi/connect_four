class Player
  attr_reader :symbol
  attr_accessor :name
  def initialize(symbol, name)
    @symbol = symbol
    @name = name
  end
end
