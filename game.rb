# encoding: utf-8

require_relative 'board'

class Game
  
  def initialize
    @board = Board.new
  end
  
  def play
    curr_color = :red
    until game_over?
      puts @board.render
      turn(curr_color)
      curr_color = (curr_color == :red ? :white : :red)
    end
    puts "Game over, #{winner} won."
  end
  
  def turn(color)
    begin
      puts "#{color}: choose moves (i.e. B3 C4 D5)"
      input = gets.chomp.split(" ")
      moves = translate(input)
      start_pos = moves.shift
      if @board.piece_color(start_pos) != color
        raise InvalidMoveError.new
      end
      @board[start_pos].perform_moves(moves)
    rescue InvalidMoveError
      puts "Invalid move. Try again."
      retry
    end
  end
  
  def game_over?
    @board.no_pieces(:red) || @board.no_pieces(:white)
  end
  
  def winner
    @board.no_pieces(:red) ? :white : :red
  end
  
  def translate(input)
    moves = []
    input.each do |coord|
      col, row = coord.split("")
      moves << [Board::ROWS[row], Board::COLUMNS[col.upcase]]
    end
    moves
  end
  
end

if $PROGRAM_NAME == __FILE__
  game = Game.new
  game.play
end