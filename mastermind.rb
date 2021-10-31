# frozen_string_literal: true

class Mastermind
  def initialize
    pattern = proc { "123456".chars.sample }
    @answer = 4.times.map(&pattern)
    @guesses = 0
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

  def compare(guess)
    result = { exact: [], near: [] }
    guess.each_with_index do |char, index|
      if exact_match?(char, index)
        result[:exact] << true
      elsif near_match?(char)
        result[:exact] << true
      end
    end
  end

  def near_match?(choice)
    @answer.include?(choice)
  end

  def exact_match?(choice, position)
    choice == @answer[position]
  end

  def guess
    puts 'Please, enter 4 numbers between 1-6'
    user_input = gets.chomp.chars
    if valid_move?(user_input)
      compare(user_input)
    else
      guess
    end
  end

  def play
    while @guesses < 12
      guess
    end
  end
end