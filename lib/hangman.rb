word_bank = File.readlines('google-10000-english-no-swears.txt')

def get_random_word(words_arr)
  word = ""
  until word.length >= 5 && word.length <= 12
        word = words_arr.sample
  end 
  return word
end

secret_word = get_random_word(word_bank)
secret_word_arr = Array.new(secret_word.length - 1, 0)

def display_word(word, display_arr)
  display_arr.each_with_index {|x, index| print x == 1 ? word[index] :'_'} 
  puts "\n\n" 
end

puts secret_word

STICKMAN_PIECES = [' O', '/|\\', ' |', '/ \\']  

def print_stick_man(form_num)
  case form_num
  when 7
    puts STICKMAN_PIECES[0]
    puts STICKMAN_PIECES[1]
    puts STICKMAN_PIECES[2]
    puts STICKMAN_PIECES[3]
  when 6
    puts STICKMAN_PIECES[0]
    puts STICKMAN_PIECES[1]
    puts STICKMAN_PIECES[2]
    puts " " + STICKMAN_PIECES[3][1...]
  when 5
    puts STICKMAN_PIECES[0]
    puts STICKMAN_PIECES[1]
    puts STICKMAN_PIECES[2]
    puts # new line
  when 4
    puts STICKMAN_PIECES[0]
    puts STICKMAN_PIECES[1]
    puts # new line
    puts # new line
  when 3
    puts STICKMAN_PIECES[0]
    puts " " + STICKMAN_PIECES[1][1...]
    puts # new line
    puts # new line
  when 2
    puts STICKMAN_PIECES[0]
    puts " " + STICKMAN_PIECES[1][1...2]
    puts # new line
    puts # new line
  when 1
    puts STICKMAN_PIECES[0]
    puts # new line
    puts # new line
    puts # new line
  else
    puts 'x_x bleh'
    puts "\t*dies dramatically*" 
    puts # new line
  end
end

def process_letter(word, word_arr, letter)
  word_arr.each_with_index {|x, index| if word[index] == letter then word_arr[index] = 1 end}
end

def display_game_board(remaining_lives, word, word_arr, guessed_letters)
  print_stick_man(remaining_lives)    
  display_word(word, word_arr)
  puts 'Guessed Letters: [' + guessed_letters.join(', ') + ']'
end

def run_game(word, word_arr)
  remaining_lives = 7
  won = false
  guessed_letters = []

  while (remaining_lives > 0) && (won == false) 
    display_game_board(remaining_lives, word, word_arr, guessed_letters)

    print 'Your Guess (\'sq\' to save & quit): '
    user_guess = gets.chomp()[0]
    if user_guess == nil || !user_guess.match?(/[[:alpha:]]/) || guessed_letters.include?(user_guess.downcase()) 
      puts '-------------------------------------'
      next 
    end
    user_guess = user_guess.downcase()
    guessed_letters.append(user_guess)

    if user_guess == 'sq' then save_game() end #TODO

    if word.include?(user_guess[0]) 
      process_letter(word, word_arr, user_guess)
    else
      remaining_lives -= 1
    end

    if word_arr.all?(1) then (won = true) end

    puts '-------------------------------------'
  end

  # add elif when save
  if won == true
    display_game_board(remaining_lives, word, word_arr, guessed_letters)
    puts "\nYOU WIN! The Secret Word was " + word
  else
    display_game_board(remaining_lives, word, word_arr, guessed_letters)
    puts "\nYOU LOSE! The Secret Word was " + word
  end
=begin
  GAME LOOP:
  - Display stickman
  - Display word array
  - Prompt user for option (optional input to save game)
    - Letter?
      - Does word include letter?
        - Yes?
          - Process letter
            - For every value of letter within word set index to 1
        - No?
          - Subtract 1 from remaining lives
    - sq: save and quit
  - Check win / loss
    - If all values in array == 1, then user has won: (won = true)
=end
end

run_game(secret_word, secret_word_arr)

def load_game(word, word_arr, progress)

end

=begin
- Word progress
  - Array (1s and 0s)
    - 1: letter has been guessed and to be displayed
    - 0: letter has not been guessed and is not displayed

- Will need to serialize in the end to save game
  - Stickman progress
  - Secret word
  - Word array
=end

