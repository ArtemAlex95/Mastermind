# frozen_string_literal: true

class Mastermind
  def initialize
    @code_colors = {
      '1' => "\e[101m  1  \e[0m ",
      '2' => "\e[43m  2  \e[0m ",
      '3' => "\e[44m  3  \e[0m ",
      '4' => "\e[45m  4  \e[0m ",
      '5' => "\e[46m  5  \e[0m ",
      '6' => "\e[41m  6  \e[0m ",
    }
    @pattern = proc { @code_colors.keys.sample }
    @answer = 4.times.map(&@pattern)
    @guesses = 0
  end

  def choice
    puts "\nDo you want to be a code-maker(1) or a code-breaker(2)?"
    user_input = gets.chomp
    case user_input
    when '1'
      self.code_maker
    when '2'
      self.play
    else
      puts 'Please, choose your role 1-2'
      choice
    end
  end

  def code_maker
    puts "\nPlease, guess your code (four-digit from 1 to 6)\n"
    @answer = gets.chomp
    if @answer.match(/^[1-6]{4}$/)
      puts "\nYour code: #{@answer}"
    else
      code_maker
    end
  end

  def display_instruction
    puts "This is a 1-player game against the computer. You\'re a code-breaker.

    There are six different numbers: #{@code_colors['1']}, #{@code_colors['2']}, #{@code_colors['3']}, #{@code_colors['4']}, #{@code_colors['5']}, #{@code_colors['6']}.

    The code maker will choose four to create a 'master code'. For example,

    #{@code_colors['1']}#{@code_colors['2']}#{@code_colors['3']}#{@code_colors['1']}

    As you can see, there can be more then one of the same number.

    In order to win, the code breaker needs to guess the 'master code' in 12 or less turns.

    After each guess, there will be up to four clues to help crack the code.

    \u25CF - this clue means you have 1 correct number in the correct location;

    \u25CB - this clue means you have 1 correct number, but in the wrong location.

    To continue the example, using the above 'master code' a guess of
    #{@code_colors['1']}#{@code_colors['3']}#{@code_colors['4']}#{@code_colors['2']} would produce 2 clues:

    Guess: #{@code_colors['1']}#{@code_colors['3']}#{@code_colors['4']}#{@code_colors['2']} Clues: \u25CF \u25CB

    The guess had 1 correct number in the correct location and 1 correct numbers in a wrong location.

    The code has been coded. Good luck!"
  end

  def valid_move?(input)
    if input.join.match(/^[1-6]{4}$/)
      true
    else
      puts 'Please, enter a four-digit code from 1 to 6'
      @guesses -= 1
      false
    end
  end

  def compare(guess, answer)
    @score = []
    wrong_guess_pegs, wrong_answer_pegs = [], []
    peg_pairs = guess.zip(answer)

    peg_pairs.each do |guess_peg, answer_peg|
      if guess_peg == answer_peg
        @score << "\u25CF"
      else
        wrong_guess_pegs << guess_peg
        wrong_answer_pegs << answer_peg
      end
    end
    wrong_guess_pegs.each do |peg|
      if wrong_answer_pegs.include?(peg)
        @score << "\u25CB"
      end
    end
    @score
  end

  def won?
    @score.map { |i| i == "\u25CF" } == [true, true, true, true]
  end

  def guess
    puts "\nPlease, enter 4 numbers between 1-6"
    user_input = gets.chomp.chars
    if valid_move?(user_input)
      compare(user_input, @answer)
      @guesses += 1
      puts "\nGuess: #{@code_colors[user_input[0]]}#{@code_colors[user_input[1]]}#{@code_colors[user_input[2]]}#{@code_colors[user_input[3]]}; Clues: #{@score.join(' ')}"
    else
      guess
    end
  end

  def play
    display_instruction
    while @guesses < 12
      puts "\nThis is guess ##{@guesses + 1} out of 12"
      guess
      if won?
        puts "\nCongrats! You broke the code!"
        break
      elsif @guesses == 12
        puts "\nBad luck :( It was a hard code! #{@code_colors[@answer[0]]}#{@code_colors[@answer[1]]}#{@code_colors[@answer[2]]}#{@code_colors[@answer[3]]}"
        break
      end
    end
    one_more?
  end

  def one_more?
    puts "\nOne more? press 'y' for one more or type 'exit'"
    user_input = gets.chomp
    Mastermind.new.play if user_input == 'y'
  end
end

Mastermind.new.choice