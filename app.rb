require "sinatra"
require "sinatra/reloader"
require "http"
require "json"

# define a route
get("/") do

  # build the API url, including the API key in the query string
  api_url = "https://api.exchangerate.host/list?access_key=#{ENV["EXCHANGE_RATE_KEY"]}"

  # use HTTP.get to retrieve the API information
  raw_data = HTTP.get(api_url)

  # convert the raw request to a string
  raw_data_string = raw_data.to_s

  # convert the string to JSON
  parsed_data = JSON.parse(raw_data_string)

  # get the symbols from the JSON
  @symbols = parsed_data.keys

  @currency_hash = parsed_data.fetch("currencies")

  # render a view template where I show the symbols
  erb(:homepage)
end

get("/:from_currency") do
  @first_currency = params.fetch("from_currency")
  
  # build the API url, including the API key in the query string
  api_url = "https://api.exchangerate.host/list?access_key=#{ENV["EXCHANGE_RATE_KEY"]}"

  # use HTTP.get to retrieve the API information
  raw_data = HTTP.get(api_url)

  # convert the raw request to a string
  raw_data_string = raw_data.to_s

  # convert the string to JSON
  parsed_data = JSON.parse(raw_data_string)

  # get the symbols from the JSON
  @symbols = parsed_data

  @currency_hash = parsed_data.fetch("currencies")

  erb(:from_currency)
end

get("/:from_currency/:to_currency") do
  @first_currency = params.fetch("from_currency")
  @second_currency = params.fetch("to_currency")
  
  # build the API url, including the API key in the query string
  api_url = "https://api.exchangerate.host/convert?access_key=#{ENV["EXCHANGE_RATE_KEY"]}&from=#{@first_currency}&to=#{@second_currency}&amount=1"

  # use HTTP.get to retrieve the API information
  raw_data = HTTP.get(api_url)

  # convert the raw request to a string
  raw_data_string = raw_data.to_s

  # convert the string to JSON
  parsed_data = JSON.parse(raw_data_string)

  @conversion_rate = parsed_data.fetch("result")

  erb(:to_currency)

end
