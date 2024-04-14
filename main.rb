require './lib/connect_four.rb'
require './lib/player.rb'

first = Player.new("X", "foo")
last = Player.new("O", "him")

game = ConnectFour.new(first, last)

game.play
