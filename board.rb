# encoding: utf-8

require_relative 'piece'
require 'colorize'

class Board
  
  attr_reader :rows
  
  def initialize(populate = true)
    create_board(populate)
  end
  
  def [](pos)
    x, y = pos
    @rows[x][y]
  end
  
  def []=(pos, piece)
    x, y = pos
    @rows[x][y] = piece
  end
  
  def move(start_pos, end_pos)
    self[start_pos], self[end_pos] = nil, self[start_pos]
    self[end_pos].pos = end_pos
  end
  
  def remove(pos)
    self[pos].pos, self[pos] = nil
  end
  
  def empty?(pos)
    self[pos].nil? ? true : false
  end
  
  def valid_pos?(pos)
    pos.all? { |coord| (0..7).include?(coord) }
  end
  
  def piece_color(pos)
    self[pos].color
  end
  
  def pieces(color)
    @rows.flatten.compact.select { |piece| piece.color == color}
  end
  
  def no_moves(color)
    !pieces(color).any? { |piece| piece.has_moves }
  end
  
  def render
    (0..7).each do |row|
      print "#{ROWS.key(row)} "
      (0..7).each do |col|
        bg_color = ((row + col) % 2 == 0 ? :light_white : :light_black)
        piece = @rows[row][col]
        if piece.nil?
          print "    ".colorize(:background => bg_color)
        else
          sym = (piece.is_king ? " ◎  " : " ◉  ")
          print sym.colorize(:color => piece.color, :background => bg_color)
        end
      end
      puts
    end
    render_col_label
    nil
  end
  
  def render_col_label
    print "   "
    (0..7).each { |col| print " #{COLUMNS.key(col)}  " }
    puts
  end
  
  def dup
    new_board = Board.new(false)
    (0..7).each do |row|
      (0..7).each do |col|
        pos = [row, col]
        piece = self[pos]
        next if piece.nil?
        new_piece = Piece.new(new_board, pos, piece.color, piece.is_king)
        new_board[[row, col]] = new_piece
      end
    end
    new_board
  end
  
  private
  
  COLUMNS = {
    "A" => 0,
    "B" => 1,
    "C" => 2,
    "D" => 3,
    "E" => 4,
    "F" => 5,
    "G" => 6,
    "H" => 7
  }
  
  ROWS = {
    "8" => 0,
    "7" => 1,
    "6" => 2,
    "5" => 3,
    "4" => 4,
    "3" => 5,
    "2" => 6,
    "1" => 7
  }
  
  def create_board(populate)
    @rows = Array.new(8) { Array.new(8) }
    if populate
      populate_rows((0..2), :white)
      populate_rows((5..7), :red)
    end
    self
  end
  
  def populate_rows(rows, color)
    rows.each do |row|
      (0..7).each do |col|
        if (row + col) % 2 != 0
          pos = [row, col]
          self[pos] = Piece.new(self, pos, color)
        end
      end
    end 
  end
  
end