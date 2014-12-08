

class VectorProcessor

	attr_accessor :input_hash, :model

	def initialize(hash_tops,array_vars)
		@input_hash = hash_tops
		@input_array = array_vars
		@array_of_tokens = []
		@exeption_id = []
		run_program
	end

	def run_program
		create_array_of_tokens
		weight_counter
		create_tokens_value
		#show_tokens
		work_model
		show_work_model
	end

	def work_model
		#MODEL     +   +   *   *   *   /   /
		@model = [[ ],[ ],[ ],[ ],[ ],[ ],[ ]]
		work_array = []
		@array_of_tokens.each {|elm| work_array << elm }
		work_array.flatten!
		work_array.each{|elm| elm.level = 0}
		backup_array = work_array

		while all_is_ready?(work_array) == false
			#Add tasks to sumators (Count = 2)
			sumator_task_push(backup_array,0)
			sumator_task_push(backup_array,1)
			#Add tasks to multiplexers (Count = 3)
			multiplexer_task_push(backup_array,2)
			multiplexer_task_push(backup_array,3)
			multiplexer_task_push(backup_array,4)
			#Add tasks to divider (Count = 2)
			divider_task_push(backup_array,5)
			divider_task_push(backup_array,6)
			
			for i in 0..@model.length-1
				for j in 0..@model[i].length-1
					if @model[i][j] == nil
						@model[i][j] = "   "
					end
				end
			end
		
			#show_work_model
		end
		#show_work_model
	end

	def divider_task_push(backup_array,div_num)
		for i in 0..backup_array.length-1
			token = backup_array[i]
			if (token.value[1] == "/") && (token.value.first.status == "ready" && token.value.last.status)
				position = [token.value.first.level,token.value.last.level].max
				if position <= @model[div_num].length && @model[div_num][position] != "   "
					@model[div_num] << token.name << token.name << token.name << token.name << token.name << token.name
					token.status = "ready"
					token.level = @model[div_num].length
					backup_array.delete_at(i)
					break
				elsif position <= @model[div_num].length && (@model[div_num][position] == "   " && @model[div_num][position+5] == "   ")
					a = token.name
					@model[div_num][position] = a
					@model[div_num][position+1] = a
					@model[div_num][position+2] = a
					@model[div_num][position+3] = a
					@model[div_num][position+4] = a
					@model[div_num][position+5] = a
					token.status = "ready"
					token.level = position+6
					backup_array.delete_at(i)
					break	
				elsif position > @model[div_num].length
					a = token.name
					@model[div_num].insert(position, a, a, a, a, a, a)
					token.status = "ready"
					token.level = @model[div_num].length
					backup_array.delete_at(i)
					break
				end
			end
		end
	end


	def multiplexer_task_push(backup_array, mul_num)
		#MULTIPLEXER WORK ALGHORITM====================
		for i in 0..backup_array.length-1
			token = backup_array[i]
			if (token.value[1] == "*") && (token.value.first.status == "ready" && token.value.last.status)
				position = [token.value.first.level,token.value.last.level].max
				if position <= @model[mul_num].length && @model[mul_num][position] != "   "
					@model[mul_num] << token.name << token.name << token.name << token.name
					token.status = "ready"
					token.level = @model[mul_num].length
					backup_array.delete_at(i)
					break
				elsif position <= @model[mul_num].length && (@model[mul_num][position] == "   " && @model[mul_num][position+3] == "   ")
					a = token.name
					@model[mul_num][position] = a
					@model[mul_num][position+1] = a
					@model[mul_num][position+2] = a
					@model[mul_num][position+3] = a
					token.status = "ready"
					token.level = position+4
					backup_array.delete_at(i)
					break	
				elsif position > @model[mul_num].length
					a = token.name
					@model[mul_num].insert(position, a, a, a, a)
					token.status = "ready"
					token.level = @model[mul_num].length
					backup_array.delete_at(i)
					break
				end
			end
		end
		#MULTIPLEXER WORK ALGHORITM====================
	end

	def show_work_model
		model_sign = ["+","+","*","*","*","/","/"]
		k = 0
		@model.each do |elm|
		print "[#{model_sign[k]}]" + " - "
			elm.each do |top|
				if top == nil
					print "[   ]" + "\t"
				else
					print "[#{top}]" + "\t"
				end
			end
			print "\n"
			k += 1
		end
	end

 	def sumator_task_push(backup_array, sum_num)
		#SUMATOR WORK ALGHORITM====================
		for i in 0..backup_array.length-1
			token = backup_array[i]
			if (token.value[1] == "-" || token.value[1] == "+") && (token.value.first.status == "ready" && token.value.last.status)
				position = [token.value.first.level,token.value.last.level].max
				if position <= @model[sum_num].length && @model[sum_num][position] != "   "
					@model[sum_num] << token.name << token.name
					token.status = "ready"
					token.level = @model[sum_num].length
					backup_array.delete_at(i)
					break
				elsif position <= @model[sum_num].length && @model[sum_num][position] == "   "
					a = token.name
					@model[sum_num][position] = a
					@model[sum_num][position+1] = a
					token.status = "ready"
					token.level = position+2
					backup_array.delete_at(i)
					break	
				elsif position > @model[sum_num].length
					a = token.name
					@model[sum_num].insert(position, a, a)
					token.status = "ready"
					token.level = @model[sum_num].length
					backup_array.delete_at(i)
					break
				end
			end
		end
		#SUMATOR WORK ALGHORITM=====================
	end



	def all_is_ready?(array)
		all_tokens = array.length
		ready_counter = 0
		for i in 0..array.length-1
			token = array[i]
			if token.status == "ready"
				ready_counter += 1
			end
		end

		if all_tokens == ready_counter
			return true 
		else
			return false
		end
	end



	def create_tokens_value
		for i in 0..@array_of_tokens.length-1
			for j in 0..@array_of_tokens[i].length-1
				@array_of_tokens[i][j].split_value
			end
		end
		
		for i in 0..@array_of_tokens.length-1
			for j in 0..@array_of_tokens[i].length-1
				token = @array_of_tokens[i][j]
				if token.value.class == Array 
					var1 = find_token(token.value.first)
					var2 = find_token(token.value.last)
					@array_of_tokens[i][j].value[0] = var1
					@array_of_tokens[i][j].value[-1] = var2
				end
			end
		end		
	end

	def find_token(arg)
		for i in 0..@array_of_tokens.length-1
			for j in 0..@array_of_tokens[i].length-1
				token = @array_of_tokens[i][j]
				if arg == token.name && @exeption_id.include?(token.object_id) == false
					@exeption_id << token.object_id
					return token
				end
			end
		end
	end


	def weight_counter
		for i in 0..@array_of_tokens[0].length-1
			@array_of_tokens[0][i].status = "ready"
		end
		for i in 1..@array_of_tokens.length-1
			for j in 0..@array_of_tokens[i].length-1
				obj = @array_of_tokens[i][j]
				index = obj.value =~ /[-+\\\/*]/
				if obj.value[index] == "+" || obj.value[index] == "-"
					obj.weight = 2
				elsif obj.value[index] == "*"
					obj.weight = 4
				elsif obj.value[index] == "/"
					obj.weight = 6
				end
				@array_of_tokens[i][j] = obj
			end
		end
		#show_tokens
	end

	def show_name_value
		for i in 0..@array_of_tokens.length-1
			for j in 0..@array_of_tokens[i].length-1
				if @array_of_tokens[i][j].value.class == Array
					puts "Name - #{@array_of_tokens[i][j].name};"+
					" Value-#{@array_of_tokens[i][j].value.first.name}#{@array_of_tokens[i][j].value[1]}"+
					"#{@array_of_tokens[i][j].value.last.name}"
				end
			end
		end
	end

	def show_tokens
		for i in 0..@array_of_tokens.length-1
			for j in 0..@array_of_tokens[i].length-1
				token = @array_of_tokens[i][j]
				if token.value.class == String
					puts "Token-#{token.name}; Status-#{token.status}; ID-#{token.object_id.to_s}; Level-#{token.level}; " + 
					"Weight-#{token.weight}; Value-[#{token.value}]"
				elsif token.value.class == Array
					puts "Token-#{token.name}; Status-#{token.status}; ID-#{token.object_id.to_s}; Weight-#{token.weight}; Level-#{token.level}" + 
					" Value-[#{token.value.first.name}#{token.value[1]}#{token.value.last.name}] => " + 
					"[#{token.value.first.object_id},#{token.value.last.object_id}]"
				end
			end
		end
	end

	def create_array_of_tokens
		array = []
		@input_array.each do |key|
			a = Token.new(key, "empty", 0)
			array << a
		end
		@array_of_tokens << array
		for i in 0..@input_hash.length-1
			array = []
			@input_hash[i].each do |key, val|
				a = Token.new(key, val, i+1)
				array << a
			end
		@array_of_tokens << array
		end
		#@array_of_tokens.each{|arr| arr.each{|tok| puts tok.name + "\t" + tok.value + "\t\t" + tok.level.to_s } }
	end

end

# str = "x/z+2+4*x+b+g/sol/t2+r+m*n*32+y/f-1/2/3"
# str = "y+2+a+b-d*x*r+y/z+y/3+z/2"
# str = "a*b+c*d*k+l*m*n+2+r/2*3"
# tasks = TreeB.new(str)
# array_of_tops = tasks.array_of_hash_tree
# array_of_vars = tasks.all_vars
# vector = VectorProcessor.new(array_of_tops, array_of_vars)
