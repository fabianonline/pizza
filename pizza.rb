require 'rubygems'
require 'sinatra'
require 'fastercsv'
require 'erb'

get '/' do
    @pizza = FasterCSV.read("pizza.csv", {:col_sep=>';'})
    erb :index
end
