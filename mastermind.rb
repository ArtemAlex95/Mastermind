#frozen_string_literal: true

class Mastermind

    def initialize
        pattern = Proc.new { "123456".chars.sample }
        @answer = 4.times.map(&pattern).join
        @guesses = 0
    end

    def valid_move?(index)
        index.between?(1, 6)
    end
    
    def guess
        puts "Please, enter a number between 1-6"
        user_input = gets.chomp
        if valid_move?(user_input)
            compare(user_input, @answer)
            display
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