require_relative 'piece'

class Board
  
  attr_accessor :rows
  
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
  
  def render
    a = @rows.map do |row|
      row.map do |el|
        if el.nil?
          " "
        else
          el.color == :white ? "W" : "R"
        end
      end.join "  "
    end.join "\n"
    print a
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
  
  def create_board(populate)
    @rows = Array.new(8) { Array.new(8) }
    if populate
      populate_rows((0..2), :white)
      populate_rows((5..7), :red)
      self[[3,2]] = Piece.new(self, [3,2], :red)
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