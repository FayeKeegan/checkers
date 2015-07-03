require_relative 'board'
require_relative 'piece'
require_relative 'empty_square'
require 'colorize'

class Checkers

	attr_accessor :current_player, :board

	def initialize
		@players = [:black, :white]
		@current_player = @players.shuffle.sample
		@board = Board.new
		@board.setup_board
	end

	def play
		puts "WELCOME TO THE GAME OF CHECKERS"
		until game_over
			board.render
			take_turn
			switch_player
		end
		puts ">>>>>>GAME OVER<<<<<<<<"
		puts "THE WINNER IS #{board.pieces.first}"
	end

	def player_message
		puts "IT IS #{current_player}'s TURN".colorize(:red)
	end


	def game_over
		board.all_pieces.all? {|piece| piece.black?} || board.all_pieces.all? {|piece| piece.white?} 
	end

	def start_pos_prompt
		puts "please enter the position of the piece you want to move... (e.g., 0,1)"
		start_pos = gets.chomp.split(",").map(&:to_i)
		raise InvalidStartError unless valid_start?(start_pos)
		start_pos
	end

	def valid_start?(start_pos)
		board.on_board?(start_pos) && board[*start_pos].checker? && board[*start_pos].color == current_player
	end

	def move_prompt
		puts "Please enter an array of the moves you want then press enter"
		puts "if entering a single move enter 1,2"
		puts "if entering multiple moves separate moves with a semicolon. e.g. 2,2;3,3;4,4"
		move_arr = gets.chomp
		move_arr.split(";")
		if move_arr.class == Array
			move_arr.map do |move|
				move.split(",").map(&:to_i)
			end
		else
			[move_arr.split(",").map(&:to_i)]
		end
	end

	def take_turn
		puts "current player: " + current_player.to_s
		begin
			start_pos = start_pos_prompt
		rescue InvalidStartError
			puts "Invalid Start"
			retry
		end
		
		move_arr = move_prompt
		if board.valid_move_seq?(start_pos, move_arr)
			board.perform_move!(start_pos, move_arr)
		else
			puts "Invalid move!"
			take_turn
		end
	end

	def switch_player
		current_player == :white ? self.current_player = :black : self.current_player = :white
	end

end

class InvalidStartError < StandardError
end

b = Checkers.new
b.play


