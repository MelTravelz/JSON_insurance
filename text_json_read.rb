####################################### Challenge: 
# Open JSON file & parse the data
# Return JSON: including the average of Market Cap of all companies, Time, and all insurance companies with a Market Cap of over 55 billion
# Ensure the return is organized similar to the input (ie. inside "InsuranceCompanies")
# Then refactor your code 

### if time allows:
# Add this insurance company: Marketz & Moneyz (MnM) with 55.1 billion
# return new average along with ins. companies as JSON


####################################### Clarification Q:
# Do we want to set up lib/spec files and write a test for this first? Or just p/puts to the terminal?
  #=> puts to the terminal please
# When we say "average" do we mean the median (the middle company's Market Cap) or the sum of all numbers divided by the total count? 
  #=> we'd like the average (sum/count)
# What key name do we want the average to be saved as? "Avg Market Cap" ok?  
  #=> yes
# How about the name of the ins. companies that are returned, "Insurance Companies Over 55B"?
  #=> yes
# For Time, do you want exact time or month & year?
  #=> either one is ok.
# Also, do we want this average to be run before or after we add the newest insurance company? 
  #=> let's do this after we add the company
  
# Does the No. of the company being added matter? (A specific location or just add to the end of the list?)
  #=> just add to the end


####################################### Match:
#I've done something exactly like this before, but the different parts I'd touched
# ex: opening JSON, parsing through JSON, averaging floats, adding an element into a collection, and returning JSON

# Sad path testing/edge case testing ideas: 
# what if theres an extra space? 
# what if one of the cap is million or thousand or trillion?
# what if the dollar sign is missing?? <- big uh-oh


####################################### PseudoCode:
#[X] open file:
# First we'll need to open the file -> variable = File.read(file_path), JSON.parse (variable, symbolize_names: true)

#[X] find over 55B companies:
# .find_all or .select
# iterate into array & find market cap, split on space, (.shift to select first element), remove first element ($), .to_i (.to_f)
# if that number is >= 55 return the object (the entire hash object)

#[X] find Avg:
# We can grab the Top Insurance Companies key and iterate through it's array-value to put all market caps into another array
# with that new array we could sum and divide by .size/.length (NOT use .count since that's another iteration and would slow the processing speed down)

#[X] build hash:
# build a hash of our JSON: Avg Market Cap, Time: Time.now (?), Insurance Companies over 55B

#[X] return JSON:
# OpenStruct.new(hash) OR JSON.generate(hash??) OR .pretty_generate OR .to_json ... we'll do more research then

#[] refactor

####################################### First Draft:
# require 'json'

# def find_ins_co_over_55b
#   all_ins_comp_data = File.read('json_test.json')
#   parsed_data = JSON.parse(all_ins_comp_data)
#   top_ins_comp = parsed_data["InsuranceCompanies"]["Top Insurance Companies"]

#   # ins comp vver 55B:
#   ins_comp_over_55b = top_ins_comp.find_all do |ins_co|
#     ins_co["Market Capitalization"].split(" ").shift.delete("$").to_f >= 55
#   end

#   # average market cap:
#   market_cap_sum = top_ins_comp.sum do |ins_co|
#     ins_co["Market Capitalization"].split(" ").shift.delete("$").to_f
#   end
#   market_cap_avg = (market_cap_sum/top_ins_comp.size).to_s #do we want this to be String or float

#   #build hash:
#   hash = {
#     "InsuranceCompanies": {
#       "Time": Time.now,
#       "Average Market Cap": market_cap_avg,
#       "Insurance Companies over 55B": ins_comp_over_55b
#       }
#   }

#   # hash.to_json
#   puts JSON.generate(hash)
# end

# # data = find_ins_co_over_55b
# # pp data

# find_ins_co_over_55b

####################################### Refactor (Phase1 - create helper methods):
# require 'json'

# def find_ins_co_over_55b
#   top_ins_comp = read_parse_select_data
#   # all_ins_comp_data = File.read('json_test.json')
#   # parsed_data = JSON.parse(all_ins_comp_data)
#   # top_ins_comp = parsed_data["InsuranceCompanies"]["Top Insurance Companies"]

#   # ins comp vver 55B:
#   ins_comp_over_55b = fetch_comp_over_55B(top_ins_comp)
#   # ins_comp_over_55b = top_ins_comp.find_all do |ins_co|
#   #   ins_co["Market Capitalization"].split(" ").shift.delete("$").to_f >= 55
#   # end

#   # average market cap:
#   market_cap_avg =  fetch_avg_market_cap(top_ins_comp)
#   # market_cap_sum = top_ins_comp.sum do |ins_co|
#   #   ins_co["Market Capitalization"].split(" ").shift.delete("$").to_f
#   # end
#   # market_cap_avg = (market_cap_sum/top_ins_comp.size).to_s #do we want this to be String or float

#   #build hash:
#   hash_ready_for_json = build_hash(market_cap_avg, ins_comp_over_55b)
#   # hash = {
#   #   "InsuranceCompanies": {
#   #     "Time": Time.now,
#   #     "Average Market Cap": market_cap_avg,
#   #     "Insurance Companies over 55B": ins_comp_over_55b
#   #     }
#   # }

#   # pp hash_ready_for_json

#   # hash.to_json
#   puts JSON.generate(hash_ready_for_json)
# end

# def read_parse_select_data
#   all_ins_comp_data = File.read('json_test.json')
#   parsed_data = JSON.parse(all_ins_comp_data)
#   parsed_data["InsuranceCompanies"]["Top Insurance Companies"]
# end

# def fetch_comp_over_55B(top_ins_comp)
#   top_ins_comp.find_all do |ins_co|
#     ins_co["Market Capitalization"].split(" ").shift.delete("$").to_f >= 55
#   end
# end

# def fetch_avg_market_cap(top_ins_comp)
#   market_cap_sum = top_ins_comp.sum do |ins_co|
#     ins_co["Market Capitalization"].split(" ").shift.delete("$").to_f
#   end
#   (market_cap_sum/top_ins_comp.size).to_s #Question: Do we want this to be String or Float?
# end

# def build_hash(market_cap_avg, ins_comp_over_55b)
#   {
#     "InsuranceCompanies" => {
#       "Time" => Time.now,
#       "Average Market Cap" => market_cap_avg,
#       "Insurance Companies over 55B" => ins_comp_over_55b
#       }
#   }
# end

# find_ins_co_over_55b

####################################### Refactor (Phase2 - Clean-up):
require 'json'

def find_ins_co_over_55b
  top_ins_comp = read_parse_select_data # Would memoization here speed up processing times since it's being passed to other methods multiple times?
  ins_comp_over_55b = fetch_comp_over_55B(top_ins_comp)  
  market_cap_avg =  fetch_avg_market_cap(top_ins_comp)
  hash_ready_for_json = build_hash(market_cap_avg, ins_comp_over_55b)

  puts JSON.generate(hash_ready_for_json)
end

# Helper Methods:
# private # Does putting these helper methods under private here make sense? 
def read_parse_select_data 
  all_ins_comp_data = File.read('json_test.json')
  parsed_data = JSON.parse(all_ins_comp_data)
  parsed_data["InsuranceCompanies"]["Top Insurance Companies"]
end

def fetch_comp_over_55B(top_ins_comp)
  top_ins_comp.find_all do |ins_co|
    grab_market_cap(ins_co) >= 55
  end
end

def fetch_avg_market_cap(top_ins_comp)
  market_cap_sum = top_ins_comp.sum do |ins_co|
    grab_market_cap(ins_co)
  end
  (market_cap_sum/top_ins_comp.size).to_s
end

def build_hash(market_cap_avg, ins_comp_over_55b)
  {
    "InsuranceCompanies" => {
      "Time" => Time.now,
      "Average Market Cap" => market_cap_avg,
      "Insurance Companies over 55B" => ins_comp_over_55b
      }
  }
end

# Helper method's Helper method!:
def grab_market_cap(ins_co)
  ins_co["Market Capitalization"].split(" ").shift.delete("$").to_f
end

find_ins_co_over_55b


#### Final Notes & Questions: 
# The `read_parse_select_data` method breaks Single Responsibility Principle, for our purposes is this ok, or would you have wanted to see this broke up even more? 
#[X] If I was to refactor again: I would see if there was a way to iterate just once and pull out the objects as well as the market caps numbers.
# I'd also see if any arguments could be keyword arguments (or if this is just for `initialize` methods)?
# Could memoization be used on the `all_ins_comp_data` variable to speed up processing times? 

# Is there anything you see that I might have missed? 
# How would you have refactored differently? 
# Are there any quick changes you see that would improve the code?