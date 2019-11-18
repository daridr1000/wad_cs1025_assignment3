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
	

	


		
	# Any code added to command line game should be added above.
	
		exit	# Does not allow command-line game to run code below relating to web-based version
	

	
	
	end
end



# End modules

# Sinatra routes

	# Any code added to web-based game should be added below.
	

	#Creating the game object
	$g=WOF_Game::Game.new(@input,@output)
	#Saving the name and the id of the student in a variable
	$credits=$g.start
	get '/' do 
		erb :home
	end
	get '/new' do
		#Reading the file which contains all the words
		$g.readwordfile("wordfile.txt")
		#Initializing the template and the secret word inside a multi-dimensional array
		secret = $g.gensecretword
		$g.setsecretword(secret)
		$g.createtemplate
		$template=$g.getsecrettemplate
		$secretword=$template[0]
		#Initializing the number of lives and the score
		$lives = 5	
		$score = 100*$secretword.length
		#Eliminating the first and the final bracket of the template
		template=$template[1]
		template=template[1..template.length-2]
		$template[1]=template
		#Revealing the existing spaces of the secret word
		for i in (0..$template[0].length)
			if $template[0][i]==" "
				$template[1][i]=" "
			end
		end
		erb :new
	end
	get '/play' do
		erb :play
	end
	#The '/new' and '/play' pages are similar, with the difference that the '/new' page restarts completely the game and the variables  


	#Initializing the array which contains all the letters
	$letters=*('A'..'Z')
	get '/start' do
		#Initializing the name of each player which will be added to the leaderboard after the players choses his/her name
		$name=""
		#Initializing the analysis message which will be displayed on the analysis page each time a game is finished
		$analysis_message=""
		#The following two arrays have been used only for the analysis page
		#Initializing the array where all the used letters will be saved
		$usedletters=Array.new
		#Initializing a boolean array which will take notice of whether an used letter is in the secret word or not
		$foundLetter=Array.new
		erb :start
	end
	post '/start' do
		#Opening the file which contains the name of the player, his/her score and the word he/she tried to guess
		file=File.open("names.txt","a")
		#Extracting the name which has been typed in the HTML input text box and saving it in a variable
		$name=params[:name]
		#Adding the name of the player to the text file
		file.puts $name
		#Closing the file
		file.close
		redirect '/new'
	end	
	get '/leaderboard' do
		#Saving all of the file information into a global array
		$files=File.open("names.txt").to_a
		#Initializing a 3 dimensional array which will contain the names, the scores of the players and the word they tried to guess 
		names=Array.new
		for i in (0..$files.length).step(3)
			#Appending the names, the scores and the words to the 3 dimensional array accordingly
			names+=[[$files[i],$files[i+1],$files[i+2]]]
		end	
		#Deleting the last remaining space
		names.delete_at(names.length-1)
		#Sorting the whole array in descending order by score 
		names=names.sort_by {|k|k[1]}.reverse
		#Transferring all the information to a global variable which is used inside the "leaderboard" erb to display the leaderboard itself 
		$files=names
		erb :leaderboard
	end
	
	post '/new' do
		#Extracting the letter which has been typed in the HTML input text box and saving it in a variable
		letter=params[:letter].upcase
		#Appending the current letter to the array where all the typed letters are saved
		$usedletters+=[letter]
		#Initially assuming that the letter hasn't been found yet in the secret word 
		foundLetter=false
		#Eliminating the typed letter from the letters array
		index=$letters.index(letter)
		$letters[index]=""
		#Checking whether the typed letter is in the secret word or not 
		for i in(0..$template[0].length)
			if letter==$template[0][i]
		#If yes, update the template by showing the letter
				$template[1][i]=letter
				#Adding true to the boolean array 
				$foundLetter+=[true] 
				#Changing the foundLetter variable into "true" as the letter is in the secret word
				foundLetter=true
			end
		end
		if foundLetter==false
			#If the letter has not been found in the secret word, append "false" in the boolean array
			$foundLetter+=[false]
			#Updating the lives and the score in accordance with to the rules 
			$lives-=1
			$score-=100
		end
		redirect '/play'
	end

	post '/play' do
		
		#Extracting the letter which has been typed in the HTML input text box and saving it in a variable
		letter=params[:letter].upcase
		#Assuming that it's the first time the player types this letter (this variable is used in the "play" erb)
		$used=false
		#Appending the current letter to the array where all the typed letters are saved
		$usedletters+=[letter]
		#Initially assuming that the letter hasn't been found yet in the secret word 
		foundLetter=false
		#Checking whether the letter has been already typed or not
		if $letters.include? letter
			#Eliminating the typed letter from the letters array
		index=$letters.index(letter)
		$letters[index]=""
			#Checking whether the typed letter is in the secret word or not 
			for i in(0..$template[0].length)
				if letter==$template[0][i]
					#If yes, update the template by showing the letter
					$template[1][i]=letter
					#Adding true to the boolean array 
					$foundLetter+=[true] 
					#Changing the foundLetter variable into "true" as the letter is in the secret word
					foundLetter=true
				end
			end
		else
			#Changing the $used variable into "true" as the letter is not anymore in the $letters array
			$used=true
		end
		if foundLetter==false 
			#If the letter has not been found in the secret word, append "false" in the boolean array
			$foundLetter+=[false]
			if $used==false # Updating the score and the lives remaining ONLY if the typed letter has not been typed before
				$lives-=1
				$score-=10*$secretword.length
			end
			
		end
		if $lives==0 or $template[0]==$template[1]
			if $template[0]==$template[1] # The player wins the game ONLY if the secret word and the template initially provided correspond
				#Setting the final analysis message accordingly 
				$analysis_message="Word guessed!<br>You won!<br>Secret word:#{$template[0]}<br>Your score:#{$score}"
			end
			if $lives==0 # The computer wins the game ONLY if the player runs out of lives
				#As the player lost, his/her score will be 0
				$score=0
				#Setting the final analysis message accordingly
				$analysis_message="You ran out of lives! <br>Computer won!<br>Secret word:#{$template[0]}<br>Your score:#{$score}"
			end
			#Opening the file which contains the name of the player, his/her score and the word he/she tried to guess
			file=File.open("names.txt","a")
			#Adding the score and the secret word to the file
			file.puts $score
			file.puts $secretword
			#Closing the file
			file.close
			redirect '/leaderboard'
		end	
		redirect '/play'
	end
	post '/leaderboard' do
		redirect '/start'
	end
	get '/analysis' do
		erb :analysis
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