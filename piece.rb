class Piece

	attr_accessor :pos, :board
	attr_reader :color

	def initialize(color, pos, board, is_king=false)
		@color = color
		@pos = pos
		@board = board
		@is_king = is_king
	end

	def is_king?
		@is_king
	end


	
end
