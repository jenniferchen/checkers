require_relative 'board'

class Piece
  
  attr_accessor :pos, :color

  def initialize(board, pos, color, is_king = false)
    @board = board
    @pos = pos
    @color = color
    @is_king = is_king
  end
  
  def perform_slide(new_pos)
    return false unless @board.valid_pos?(new_pos)
    dx = new_pos[0] - @pos[0]
    dy = new_pos[1] - @pos[1]
    if move_diffs.include?([dx, dy])
      @board.move(@pos, new_pos) if @board.empty?(new_pos)
      true
    else
      false
    end
  end
      
  # def perform_slide(new_pos)
  #   possible_moves = []
  #   move_diffs.each do |diff|
  #     dx, dy = diff
  #     possible_moves = [@pos[0] + dx, @pos[1] + dy]
  #   end
  #   if possible_moves.include?(new_pos) 
  #     perform_moves!(new_pos) if @board.valid_pos?(new_pos) && @board.empty?(new_pos)
  #     true
  #   else
  #     false
  #   end
  # end
  
  def perform_jump(new_pos)
    return false unless @board.valid_pos?(new_pos)
    dx = new_pos[0] - @pos[0]
    dy = new_pos[1] - @pos[1]
    jumped_pos = [@pos[0] + dx / 2, @pos[1] + dy / 2]
    
    if double(move_diffs).include?([dx, dy]) && enemy?(jumped_pos)
      @board.move(@pos, new_pos)
      @board.remove(jumped_pos)
      true
    else
      false
    end
  end
  
  # need to revisit
  def valid_move_seq?(moves)
    dup_board = @board.dup
    if dup_board[@pos].perform_moves!(moves)
      @board = dup_board
    else
    end
  end
  
  def perform_moves!(moves)
    moves.each do |new_pos|
      @board.move(@pos, new_pos)
    end
  end
  
  def enemy?(pos)
    !@board.empty?(pos) && @board.piece_color(pos) != @color
  end
  
  def move_diffs
    if @is_king
      WHITE_STEP + RED_STEP
    else
      @color == :white ? WHITE_STEP : RED_STEP
    end
  end
  
  def double(steps)
    steps.map do |step|
      step.map { |coord| coord * 2 }
    end
  end
  
  WHITE_STEP = [
    [1, 1],
    [1, -1]
  ]
  
  RED_STEP = [
    [-1, 1],
    [-1, -1]
  ]
  
end