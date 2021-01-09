require 'sinatra'
require 'sinatra/reloader'
require "sinatra/cookies"

enable :sessions

#declare and initialize first word globaly
# you can change it by your own
targetWord = 'cargo'

#
# show game page
#
get '/' do
    @alphabet = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h',
    'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's',
    't', 'u', 'v', 'w', 'x', 'y', 'z']
    @userLives = targetWord.length() - 1
    session[:user_lives] = @userLives
    session[:correct_guesses] = 0
    @targetWordCount = targetWord.length()

    erb :'home_view'
end

#
# check if letter guessed correctly
#
post '/check_letter' do
    #check if user has won
    won = false
    if(session[:correct_guesses] == targetWord.length()-1)
        won = true
    end

    # if user's lives finished, halt the request
    if(session[:user_lives] == 0)
        response =  {
            guess: false,
            lives: session[:user_lives],
            won: won
        }.to_json
        halt response
    end

    # if letter is not in the word, decrese lives by one
    if ! targetWord.include? params["letter"]
        session[:user_lives] = session[:user_lives] -1
        puts session[:user_lives]
        {
            guess: false,
            lives: session[:user_lives],
            won: won
        }.to_json

    else
        index = targetWord.index(params["letter"])
        session[:correct_guesses] = session[:correct_guesses] + 1

        {
            guess: true,
            position: index,
            lives: session[:user_lives],
            won: won
        }.to_json
    end
end

#
# reset the game
#
get '/reset_game' do
    #reset session
    session[:user_lives] = targetWord.length() - 1
    session[:correct_guesses] = 0
end

#
# show hint
#
get '/hint' do
    {
        hint: "it's made of 2 words, they put the [whole word] on the [first word] and [second word] away"
    }.to_json
end



