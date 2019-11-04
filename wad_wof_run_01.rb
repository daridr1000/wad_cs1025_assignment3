# Ruby code file - All your code should be located between the comments provided.

# Add any additional gems and global variables here
require 'sinatra'		

# The file where you are to write code to pass the tests must be present in the same folder.
# See http://rspec.codeschool.com/levels/1 for help about RSpec
require "#{File.dirname(__FILE__)}/wad_wof_gen_01"
set	:bind,'0.0.0.0'

# Main program
module WOF_Game
	@input = STDIN
	@output = STDOUT
	g = Game.new(@input, @output)
	playing = true
	input = ""
	menu = ""
	guess = ""
	secret = ""
	filename = "wordfile.txt"
	turn = 0
	win = 0
	game = ""
	words = 0
	@output.puts 'Enter "1" runs game in command-line window or "2" runs it in web browser.'
	game = gets.chomp
	if game == "1"
		puts "Command line game"
	elsif game == "2"
		puts "Web-based game"
		
	else
		puts "Invalid input! No game selected."
		exit
	end
		
	if game == "1"
		
	# Any code added to command line game should be added below.
	g.start
	g.resetgame
	words = g.readwordfile(filename)
	if  words == 0
		@output.puts 'Error reading file.'
		exit
	end
#		@output.puts g.wordtable.inspect
#		@output.puts "Words: #{words}"
	secret = g.gensecretword
	g.setsecretword(secret)
#		@output.puts "Secret word:" + g.secretword
	g.createtemplate
	g.displaytemplate
	
	while menu != "9"
		g.displaymenu
		puts g.menuprompt
		menu = gets.chomp
		if menu == "1"
			guess = "_"
			while guess != "" && turn < (GOES) && win != 1
				g.displaytemplate
				@output.puts 'Guess a missing charater from the hidden word/phrase. Enter returns to menu.'
				guess = g.getguess
				@output.puts "You entered: #{guess}"	#need to check value overwritten
				g.storeguess(guess)
				if g.charinword(guess) > 0
					@output.puts "Character #{guess} is in word."
					g.showcharinword(guess)
					win = g.checkifwon
					if win == 1
						g.incrementscore
						g.incrementplayed
							@output.puts "You win!"	#need to check value overwritten
						g.revealword
					end
				else
					if guess != ""
						turn = turn + 1
						g.incrementplayed
						g.incrementturn
					end
				end
				@output.puts "You have #{g.getturnsleft} lives left."
				if turn >= (GOES)
						@output.puts "You lose!"
					
					g.revealword
				end
			end
		elsif menu == "2"		# Reset game
			turn = 0
			win = 0
			@output.puts "New game...\n"
			g.resetgame
			words = g.readwordfile(filename)
			if  words == 0
				@output.puts 'Error reading file.'
				exit
			end
			@output.puts g.wordtable.inspect
			@output.puts "Words: #{words}"
			secret = g.gensecretword
			g.setsecretword(secret)
			@output.puts "Secret word:" + g.secretword
			g.createtemplate
			g.displaytemplate
		elsif menu == "3"
			g.displayanalysis
		elsif menu == "9"
			@output.puts "\n"
		elsif menu == "~"
			g.displaysecretword
		else
			@output.puts "Invalid input entered."
		end
	end
	@output.puts "The secret word was: "
	g.revealword
	g.finish

	


		
	# Any code added to command line game should be added above.
	
		exit	# Does not allow command-line game to run code below relating to web-based version
	
else
	if game=='2'
		words = g.readwordfile(filename)
	secret = g.gensecretword
	g.setsecretword(secret)
	g.createtemplate
	$template=g.getsecrettemplate
	#Eliminating the first and the final bracket of the template
	template=$template[1]
	template=template[1..template.length-2]
	$template[1]=template
	end
end

end

# End modules

# Sinatra routes

	# Any code added to web-based game should be added below.
	
	get '/' do 
		erb :layout
	end
	post '/' do
		letter=params[:letter].upcase
		for i in(0..$template[0].length)
			if letter==$template[0][i]
				$template[1][i]=letter
			end
		end
		redirect '/'
	end
	# Any code added to web-based game should be added above.

# End program