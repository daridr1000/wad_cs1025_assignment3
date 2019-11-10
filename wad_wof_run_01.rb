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
	

	
	
	end
end



# End modules

# Sinatra routes

	# Any code added to web-based game should be added below.
	

	
	
	get '/' do 
		erb :home
	end

	$letters=*('A'..'Z')
	#Initialization of the number of lives
	
	get '/new' do
		$numberOfLetters=0
		$lives = 5
		
		$spaces = 0
		g=WOF_Game::Game.new(@input,@output)
		words = g.readwordfile("wordfile.txt")
		secret = g.gensecretword
		g.setsecretword(secret)
		g.createtemplate
		$template=g.getsecrettemplate
		$secretword=$template[0]
		$score = 100*$secretword.length
	#Eliminating the first and the final bracket of the template
		template=$template[1]
	 
		template=template[1..template.length-2]
		$template[1]=template
		#Eliminating existing spaces
		for i in (0..$template[0].length)
			if $template[0][i]==" "
				$spaces+=1
				$template[1][i]=" "
			end
		end
		
		erb :new
	end
	

	get '/play' do
		erb :play
	end


	get '/start' do
		erb :start
	end

	post '/new' do
		foundLetter=false
		letter=params[:letter].upcase
		index=$letters.index(letter)
		$letters[index]=""
		for i in(0..$template[0].length)
			if letter==$template[0][i]
				$template[1][i]=letter
				$numberOfLetters+=1
				foundLetter=true
			
			else
				
			end
		end
		if foundLetter==false
			$lives-=1
			$score-=100
		end
		redirect '/play'
	end
	
	post '/play' do
		foundLetter=false
		letter=params[:letter].upcase
		if $letters.include? letter
		index=$letters.index(letter)
			$letters[index]=""
			for i in(0..$template[0].length)
				if letter==$template[0][i]
					$template[1][i]=letter
					$numberOfLetters+=1
					foundLetter=true
				
				end
			
			end
		end
		if foundLetter==false
			$lives-=1
			$score-=10*$secretword.length
		end
		if $template[0]==$template[1]
			file=File.open("names.txt","a")
				file.puts $score
				file.puts $secretword
	      	  file.close
			redirect '/leaderboard'
		end	
		if $lives==0
			$score=0
			file=File.open("names.txt","a")
				file.puts $score
				file.puts $secretword
	      	  file.close
			redirect '/leaderboard'
		end
		redirect '/play'
	end
	
	get '/leaderboard' do
		
		erb :leaderboard
	end
	
	
	post '/start' do
		
		file=File.open("names.txt","a")
			file.puts params[:name]
		file.close
		redirect '/new'
	end	
	
	
	get '/notfound' do
		erb :notfound
	end

	
	not_found do
		status 404
		redirect '/notfound'
	  end
	# Any code added to web-based game should be added above.

# End program