require 'open-uri'
require 'JSON'

class GamesController < ApplicationController
  def new
    @grid = (1..11).map do
      ('A'..'Z').to_a.sample
    end
  end

  def score
    @grand_score = session[:score] || 0
    @grid = params[:grid]
    @result = params['new']
    @letters = @result.upcase.chars
    response = open("https://wagon-dictionary.herokuapp.com/#{@result}")
    json = JSON.parse(response.read)
    if @letters.all? { |letter| @letters.count(letter) <= @grid.count(letter) }
      if json['found']
        @answer = "Congratulations! #{@result} is a valid English word!"
        @grand_score += @result.length
      else
        @answer = "Sorry but #{@result} does not seem to be a valid English word..."
      end
    else
      @answer = "Sorry but #{@result} can't be buit out of #{@grid}"
    end
    session[:score] = @grand_score
  end
end
