require_relative 'game'

if $PROGRAM_NAME == __FILE__
  game = Game.new
  game.play
end