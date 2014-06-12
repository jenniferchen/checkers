# encoding: utf-8

require_relative 'board'

class Game
  
  def initialize
    @board = Board.new
  end
  
  def play
    curr_color = :red
    until game_over?
      @board.render
      turn(curr_color)
      curr_color = (curr_color == :red ? :white : :red)
    end
    puts "Game over, #{@winner} won."
  end
  
  private
  
  def turn(color)
    begin
      puts "#{color}: choose moves (i.e. B3 C4 D5)"
      input = gets.chomp.split(" ")
      unless valid_input(input)
        raise InvalidMoveError.new
      end
      moves = translate(input)
      start_pos = moves.shift
      if @board[start_pos].nil? || @board.piece_color(start_pos) != color
        raise InvalidMoveError.new
      end
      @board[start_pos].perform_moves(moves)
    rescue InvalidMoveError
      puts "Invalid move. Try again."
      retry
    end
  end
  
  def game_over?
    if @board.pieces(:red).empty? || @board.no_moves(:red)
      @winner = :white
    elsif @board.pieces(:white).empty? || @board.no_moves(:white)
      @winner = :red
    else
      false
    end
  end
  
  def winner
    @board.pieces.empty?(:red) ? :white : :red
  end
  
  def translate(input)
    moves = []
    input.each do |coord|
      col, row = coord.split("")
      moves << [Board::ROWS[row], Board::COLUMNS[col.upcase]]
    end
    moves
  end
  
  def valid_input(input)
    input.all? { |coord| coord.match(/[A-z][0-8]/) }
  end
  
end