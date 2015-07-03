require "IO/console"
require 'colorize'
require 'byebug'

require_relative 'board'
require_relative 'piece'
require_relative 'display'
require_relative 'empty_square'


class Checkers
	attr_accessor :current_player, :board
	attr_reader :display

	def initialize(display)
		@players = [:black, :white]
		@current_player = @players.shuffle.sample
		@board = Board.new(display)
		@display = display
		self.board.setup_board
		puts "display id " + display.object_id.to_s
	end

	def play
		puts "WELCOME TO THE GAME OF CHECKERS"
		until game_over
			take_turn
			switch_player
		end
		puts ">>>>>>GAME OVER<<<<<<<<"
		puts "THE WINNER IS #{board.all_pieces.first}"
	end

	def player_message
		puts "IT IS #{current_player}'s TURN".colorize(:red)
	end


	def game_over
		board.all_pieces.all? {|piece| piece.black?} || board.all_pieces.all? {|piece| piece.white?} 
	end

	def start_pos_prompt
		begin 
			self.display.unclick
			until display.clicked?
				display.unclick
				system "clear"
				board.render
				puts "current_player: " + current_player.to_s
				puts "Move cursor using W, A, S, D. Enter to pick up a piece"
				puts "cursor: " + display.cursor_position.to_s
				display.get_input
			end
			start_pos = display.cursor_position
			raise InvalidStartError unless valid_start?(start_pos)
		rescue InvalidStartError
			puts "That's an invalid selection"
			retry
		end
		start_pos
	end

	def valid_start?(start_pos)
		if !board.on_board?(start_pos)
			puts "Not on the board"
			return false
		elsif board[*start_pos].empty?
			puts "Empty Square"
			return false
		elsif board[*start_pos].color != current_player
			puts "wrong color"
			return false
		end
		true
	end

	def move_prompt
		begin
			done = false
			selected_moves = []
			until done
				system "clear"
				board.render
				puts "selected moves: " + selected_moves.to_s
				move_directions
				display.unclick
				display.get_input
				if display.clicked?
					system "clear"
					board.render
					selected_moves << display.cursor_position
					puts "selected moves: " + selected_moves.to_s
					display.unclick				
					puts "Press Z again to end the sequence"
					done = true if display.get_input == "z"
				end
			end
		end
		selected_moves
	end

	def move_directions
		puts "current_player: " + current_player.to_s
		puts "Please select the square (or squares) that you want to move to"
		puts "Once you've selected a square you can hit Z that you're done selecting squares"
	end

	def take_turn
		start_pos = start_pos_prompt

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

my_display = Display.new
my_game = Checkers.new(my_display)
my_game.play
