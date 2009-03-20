# uses yaml to get at configuration file
require 'yaml'

class ElizaController < ApplicationController

  OPENING_STATEMENT =  "<div>" + "<span class='elizaLabel'>Eliza:</span> Hello there.</div>"	
 
	def initialize
		@eliza_rules = YAML::load( File.open( RULES_FILE ) )
	end

  def unknown_request
  	redirect_to(:action => "index")
  end

  def index	
	  if request.xhr?
		  newInput = params[:newStatement]
			elizaResponse = user_statement(newInput) + eliza_statement(newInput)    	
		  render( :text => elizaResponse, :layout => false) 
		else
			reset	  
		end
  end

  protected
    def reset
    	 @conversation = OPENING_STATEMENT
    end

    def user_statement(text)
    	if text.eql?(nil)
    		return "" 
    	end
    	return "<div>" + "<span class='userLabel'>Patient:</span> " + text + "</div>"	
    end

    def eliza_statement(text)
      if text.eql?(nil)
  	    return "" 
  	  end
    
  	  response = use_eliza_rules(text)

  	  return "<div>" + "<span class='elizaLabel'>Eliza:</span> " + response + "</div>"	
    end

  	# uses global array of rules
  	def use_eliza_rules(input)

  		# process the input into an array of words
  		# want to avoid matching on fragments, like "no" of "if"
  		tokens = input.downcase.chomp.split(/ /)
		
      # default response
  		response = "Go on."
		
  		# try all the rules
  		@eliza_rules.keys.each do |curr_key|

  			current_rule = curr_key.to_s
			
    		if check_match(tokens, current_rule)
  		  
  				# get the list of responses for this rule
  				responses = @eliza_rules[current_rule]
  		
  				# choose a response from the list of responses for the rule 
  				response = responses[rand(responses.length)]
			
  				# pull out the interesting bit of the input - after the word we key in on.	
  				starting_point =  input.downcase.index(current_rule)
	
  				tmp_sliced = input.slice(starting_point + current_rule.length + 1, input.length)
				
  				if not(tmp_sliced.eql?(nil))
  					# change the viewpoint of the result
  					tmp_sliced = switch_viewpoint(tmp_sliced)
			
  					# apply the transformation, from ?y to the rest of the text
  					response = response.sub(/REPLACEME/,  tmp_sliced)	
  				end
  		  end
  		end
		
  	  response
  	end

    def check_match(tokens, current_rule)

      rule_tokens = current_rule.downcase.chomp.split(/ /)

      # loop through the tokens
      for i in (0..(tokens.length-1)) do
      
        j = 0
        while (tokens[i+j].eql?(rule_tokens[j]) and j < rule_tokens.length)  
          j +=1
        end

        if j.eql?(rule_tokens.length)
          return true
        end      
      end
    
      return false
    end

  	#	"Change I to you and vice versa, and so on."
  	# TODO: improve to handle commas and periods next to swapped words
  	def  switch_viewpoint (words)
  		new_string = ""
		
  		# TODO move to config file
  		viewpoints = {"i" => "you", "you" => "I", "me" => "are", "my" => "your"}
		
  		words.split.each do |word|
  			if(viewpoints[word.downcase])
  				word = viewpoints[word.downcase]
  			end	
			
  			new_string += word + " "		
  		end
		
  		# trim trailing space
  		new_string.chop
  	end
end
