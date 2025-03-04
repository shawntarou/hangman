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
  puts 
end

puts secret_word
display_word(secret_word,secret_word_arr)

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
  when 4
    puts STICKMAN_PIECES[0]
    puts STICKMAN_PIECES[1]
  when 3
    puts STICKMAN_PIECES[0]
    puts " " + STICKMAN_PIECES[1][1...]
  when 2
    puts STICKMAN_PIECES[0]
    puts " " + STICKMAN_PIECES[1][1...2]
  when 1
    puts STICKMAN_PIECES[0]
  else
  end
end

=begin
- Word progress
  - Array (1s and 0s)
    - 1: letter has been guessed and to be displayed
    - 0: letter has not been guessed and is not displayed

- Will need to serialize in the end to save game
=end

