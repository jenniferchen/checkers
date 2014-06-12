require_relative 'board'

class InvalidMoveError < StandardError
end

class Piece
  
  attr_accessor :pos, :color, :is_king

  def initialize(board, pos, color, is_king = false)
    @board = board
    @pos = pos
    @color = color
    @is_king = is_king
  end
  
  def perform_moves(moves)
    if valid_move_seq?(moves)
      perform_moves!(moves)
    else
      raise InvalidMoveError.new
    end
  end
  
  def valid_move_seq?(moves)
    dup_board = @board.dup
    begin
      dup_board[@pos].perform_moves!(moves)
    rescue InvalidMoveError
      false
    else
      true
    end
  end
  
  def perform_moves!(moves)
    if moves.length > 1
      moves.each do |new_pos| 
        raise InvalidMoveError.new unless perform_jump(new_pos) 
      end
    else
      move = moves.first
      raise InvalidMoveError.new unless perform_slide(move) || perform_jump(move)
    end
  end
  
  private
  
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