require 'rubygems'
require 'sinatra'
require 'erb'

if RUBY_VERSION < '1.9'
  require 'faster_csv'
else
  require 'csv'
  FCSV = CSV
end

get '/' do
    @pizza = FCSV.read("pizza.csv", {:col_sep=>';'})
    erb :index
end

post '/' do
    pizzen = FCSV.read("pizza.csv", {:col_sep=>';'})
    return "Du hast eine komische Pizza-ID angegeben..." unless pizzen[params[:pizza_id].to_i]
    return "Bitte einen Namen angeben" if params[:name].empty?
    
    pizza = pizzen[params[:pizza_id].to_i]
    pizza_name = "#{pizza[0]} #{pizza[2]}"
    pizza_name+= ", #{pizza[4]}" unless pizza[4].empty?
    line1 = "\n#{params[:name]}:\n"
    line2 = "  %-4s  %-52s %5s\n" % [pizza[1], pizza_name, pizza[5].insert(-3, ',')]
    line3 = ""
    line3 = "    #{params[:anmerkungen]}\n" unless params[:anmerkungen].empty?
    
    File.open("bestellungen.txt", "a") do |f|
        f.write(line1+line2+line3)
    end
    
    'Bestellung erfolgreich eingetragen. Noch eine Bestellung? <a href=".">Hier klicken.</a>'
end

get '/list/complete' do
    return "<pre>" + File.open("bestellungen.txt", "r") {|f| f.read } + "</pre>"
end

get '/list/short' do
    return "<pre>" + File.open("bestellungen.txt", "r") {|f| f.readlines.select{|l| l[1]==32}}.join + "</pre>"
end

get '/list/delete' do
    File.open("bestellungen.txt", "w") {|f| }
    "Datei erfolgreich geleert."
end