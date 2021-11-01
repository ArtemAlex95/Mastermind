# frozen_string_literal: true

class Mastermind
  def initialize
    pattern = proc { '123456'.chars.sample }
    @answer = 4.times.map(&pattern)
    @guesses = 0
  end

  def display_instruction
    puts "This is a 1-player game against the computer. You\'re a code-breaker.

    There are six different numbers: 1, 2, 3, 4, 5, 6.

    The code maker will choose four to create a 'master code'. For example,

    1231

    As you can see, there can be more then one of the same number.

    In order to win, the code breaker needs to guess the 'master code' in 12 or less turns.

    After each guess, there will be up to four clues to help crack the code.

    \u25CF - this clue means you have 1 correct number in the correct location;

    \u25CB - this clue means you have 1 correct number, but in the wrong location.

    To continue the example, using the above 'master code' a guess of '1342' would produce 2 clues:

    Guess: 1342 Clues: \u25CF \u25CB

    The guess had 1 correct number in the correct location and 1 correct numbers in a wrong location.

    The code has been coded. Good luck!"
  end

  def valid_move?(input)
    arr = []
    input.each do |i|
      if i.between?('1', '6')
        arr.push(i)
        if arr.count == 4
          return true
        else
          puts 'Please, enter 4 numbers between 1-6'
          return false
        end
      else
        puts 'Please, enter 4 numbers between 1-6'
        return false
      end
    end
  end

  def near_match?(choice)
    @answer.include?(choice)
  end

  def exact_match?(choice, position)
    choice == @answer[position]
  end

  def compare(guess)
    result = { exact: [], near: [] }
    guess.each_with_index do |char, index|
      if exact_match?(char, index)
        result[:exact] << "\u25CF"
      elsif near_match?(char)
        result[:exact] << "\u25CB"
      end
    end
  end

  def won?
    result[:exact].count == 4
  end

  def guess
    puts 'Please, enter 4 numbers between 1-6'
    user_input = gets.chomp.chars
    if valid_move?(user_input)
      compare(user_input)
      @guesses += 1
    else
      guess
    end
  end

  def play
    display_instruction
    while @guesses < 13
      guess
      if won?
        puts 'Congrats! You broke the code!'
        break
      else
        puts 'Bad luck :( One more?'
        one_more?
      end
      one_more?
    end
  end

  def one_more?
    puts "\nOne more? press 'y' for one more or type 'exit'"
    user_input = gets.chomp
    Mastermind.new.play if user_input == 'y'
  end
end

test = Mastermind.new.play