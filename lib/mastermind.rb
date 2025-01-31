# frozen_string_literal: true

### Game interface ########################################

# Turn 1 (12 remaining)
# Enter your code guess: gets # example: 1357
#
# [1] [3] [5] [7] (colored)
# "Correct color, at right place: 1 guesses"
# "Correct color, at wrong place: 2 guesses"
# "Incorrect color              : 1 guesses"

###########################################################
require 'colorize'
require 'io/console'

# Colors hash & its printing
COLORS_HASH = {
  1 => '1'.colorize(:red),
  2 => '2'.colorize(:green),
  3 => '3'.colorize(:blue),
  4 => '4'.colorize(:yellow),
  5 => '5'.colorize(:gray),
  6 => '6'.colorize(:cyan),
  7 => '7'.colorize(:magenta),
  8 => '8'.colorize(:light_red)
}.freeze

# Selecting code maker & code breaker (person or computer)
def select_roles
  roles_hash = { maker: nil, breaker: nil }
  roles_hash.each_key do |role|
    puts "Select the code #{role}:
  > press '1' for Player
  > press '2' for Computer"
    user_input = gets.chomp.to_i
    roles_hash[role] = user_input == 1 ? 'user' : 'comp'
  end
  roles_hash
end

# Code maker
def make_code(code_maker)
  return Array.new(4) { (1..8).to_a.sample } if code_maker == 'comp'

  puts 'Code maker, please enter your secret code: '
  secret_code_a = $stdin.noecho(&:gets).chomp # For hidden input
  secret_code_a.split('').map(&:to_i)
end

# Code breaker

## Printing at start of turn
def print_turn_start(turn)
  puts "Turn #{turn} (#{12 - turn + 1} remaining)"
  print 'Colors & their indices: '
  COLORS_HASH.each_value { |color| print "#{color} " }
  puts ' '
end

## Getting input of guess for 4 places. Format: '1486'
def take_guess(code_breaker)
  if code_breaker == 'user'
    puts 'Enter your code guess:'
    guess_a = gets.chomp.split('').map(&:to_i)
  else
    guess_a = Array.new(4) { (1..8).to_a.sample }
  end
  p_guess_a = guess_a.map { |i| COLORS_HASH[i] }
  puts "
[#{p_guess_a[0]}] [#{p_guess_a[1]}] [#{p_guess_a[2]}] [#{p_guess_a[3]}]"
  guess_a
end

## Giving hint as per input & secret code
def give_hint(guess_a, secret_code_a)
  o = 0 # Correct color, at right place
  x = 0 # Incorrect color
  secret_code_arr = secret_code_a[0..] # copy of secret code array
  guess_arr = guess_a[0..] # copy of guess array

  4.times do |i|
    next unless guess_arr[i] == secret_code_arr[i]

    o += 1
    guess_arr[i] = nil
    secret_code_arr[i] = nil
  end

  4.times do |i|
    next if guess_arr[i].nil?

    x += 1 unless secret_code_arr.include? guess_arr[i]
  end

  puts "Correct color, at right place: #{o} guesses
Correct color, at wrong place: #{4 - o - x} guesses
Incorrect color              : #{x} guesses

 "
end

## Checking for win & game over
def win_or_game_over?(guess_a, secret_code_a, turn)
  if guess_a == secret_code_a
    puts 'Code breaker is the MASTERMIND!'
  elsif turn == 12
    puts 'GAME OVER for the code breaker!'
  else
    return
  end
  arr = secret_code_a.map { |i| COLORS_HASH[i] }
  puts "Code: [#{arr[0]}] [#{arr[1]}] [#{arr[2]}] [#{arr[3]}]"
  true
end

# Code breaker
def break_code(secret_code_a, code_breaker)
  puts "Let's break the code!\n" if code_breaker == 'user'
  puts "I'll break your code!\n" if code_breaker == 'comp'
  12.times do |turn|
    turn += 1 # because loop starts from 0 & we want 1
    print_turn_start(turn)
    guess_a = take_guess(code_breaker)
    give_hint(guess_a, secret_code_a)
    break if win_or_game_over?(guess_a, secret_code_a, turn)
  end
end

##################################################################

# Gameplay

def play
  puts "### MASTERMIND ###\n
Welcome to the new game
 "
  roles_hash = select_roles
  secret_code_a = make_code(roles_hash[:maker])
  break_code(secret_code_a, roles_hash[:breaker])
end

##############################################################

play
