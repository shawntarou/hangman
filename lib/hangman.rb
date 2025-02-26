word_bank = File.readlines('google-10000-english-no-swears.txt')

def get_random_word(words_arr)
  word = ""
  until word.length >= 5 && word.length <= 12
        word = words_arr.sample
  end 
  return word
end

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

prints_stick_man(7)
