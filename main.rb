require './lib/connect_four.rb'
require './lib/player.rb'

first = Player.new("\u2689", "foo")
last = Player.new("\u2687", "him")

game = ConnectFour.new(first, last)

game.play
