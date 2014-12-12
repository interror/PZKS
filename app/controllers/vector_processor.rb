class VectorProcessor

	attr_accessor :input_hash, :model, :length_layer

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
		#show_name_value
		@length_layer = max_length_layer
		add_nil_to_the_end(@length_layer)
		#show_work_model
	end

	def max_length_layer
		max_elemetn = []
		for i in 0..@model.length-1
			for j in 0..@model[i].length-1	
				max_elemetn << @model[i][j].length
			end
		end
		return max_elemetn = max_elemetn.max
	end

	def add_nil_to_the_end(max_elemetn)
		for i in 0..@model.length-1
			for j in 0..@model[i].length-1	
				@model[i][j].insert(max_elemetn, nil)
				@model[i][j].pop
			end
		end
	end

	def work_model
		@model = [[[],[]],[[],[]],
							[[],[],[],[]],[[],[],[],[]],[[],[],[],[]],
							[[],[],[],[],[],[]],[[],[],[],[],[],[]]]
		work_array = []
		@array_of_tokens.each {|elm| work_array << elm }
		work_array.flatten!
		work_array.each{|elm| elm.level = 0}
		backup_array = work_array

		while all_is_ready?(work_array) == false
			array_of_mul = get_mult_operations(backup_array)
			array_of_sum = get_sum_operations(backup_array)
			array_of_div = get_div_operations(backup_array)
			#Add tasks to sumators (Count = 2)
			unless array_of_sum.empty?
				sum_num = 0
				array_of_sum.each do |token|
					sumator_task_push(token,sum_num)
					sum_num += 1
					sum_num = 0 if sum_num > 1
				end
			end
			#Add tasks to multiplexers (Count = 3)
			unless array_of_mul.empty?
				mul_num = 2
				array_of_mul.each do |token|
					multiplexer_task_push(token,mul_num)
					mul_num += 1
					mul_num = 2 if mul_num > 4
				end
			end
			#Add tasks to divider (Count = 2)
			unless array_of_div.empty?
				div_num = 5
				array_of_div.each do |token|
					divider_task_push(token,div_num)
					div_num += 1
					div_num = 5 if div_num > 6
				end		
			end
		end
		#show_work_model
	end

	def get_div_operations(backup_array)
		operations = backup_array.count{|token| token.value[1] == "/" && (token.value.first.status == "ready" && token.value.last.status == "ready") }
		array_of_tasks = []
		while operations > array_of_tasks.length
			for i in 0..backup_array.length-1
				token = backup_array[i]
				if token.value[1] == "/" && (token.value.first.status == "ready" && token.value.last.status == "ready")
					array_of_tasks << token
					backup_array.delete_at(i)
					break
				end
			end
		end
		return array_of_tasks
	end

	def get_mult_operations(backup_array)
		operations = backup_array.count{|token| token.value[1] == "*" && (token.value.first.status == "ready" && token.value.last.status == "ready") }
		array_of_tasks = []
		while operations > array_of_tasks.length
			for i in 0..backup_array.length-1
				token = backup_array[i]
				if token.value[1] == "*" && (token.value.first.status == "ready" && token.value.last.status == "ready")
					array_of_tasks << token
					backup_array.delete_at(i)
					break
				end
			end
		end
		return array_of_tasks
	end

	def get_sum_operations(backup_array)
		operations = backup_array.count{|token| (token.value[1] == "-" || token.value[1] == "+") && (token.value.first.status == "ready" && token.value.last.status == "ready") }
		array_of_tasks = []
		while operations > array_of_tasks.length
			for i in 0..backup_array.length-1
				token = backup_array[i]
				if (token.value[1] == "-" || token.value[1] == "+") && (token.value.first.status == "ready" && token.value.last.status == "ready")
					array_of_tasks << token
					backup_array.delete_at(i)
					break
				end
			end
		end
		return array_of_tasks
	end



	def divider_task_push(token,div_num)
		position = [token.value.first.level, token.value.last.level].max
		@model[div_num][0]
		if @model[div_num][0][position] == nil
			@model[div_num][0][position] = token.name
			@model[div_num][1][position+1] = token.name
			@model[div_num][2][position+2] = token.name
			@model[div_num][3][position+3] = token.name
			@model[div_num][4][position+4] = token.name
			@model[div_num][5][position+5] = token.name
			token.level = position+6
			token.status = "ready"
		elsif @model[div_num][0][position] != nil
			new_position = @model[div_num][0].length
			@model[div_num][0][new_position] = token.name
			@model[div_num][1][new_position+1] = token.name
			@model[div_num][2][new_position+2] = token.name
			@model[div_num][3][new_position+3] = token.name
			@model[div_num][4][new_position+4] = token.name
			@model[div_num][5][new_position+5] = token.name
			token.level = new_position+6
			token.status = "ready"
		end
	end

	def multiplexer_task_push(token, mul_num)
		position = [token.value.first.level, token.value.last.level].max
		@model[mul_num][0]
		if @model[mul_num][0][position] == nil
			@model[mul_num][0][position] = token.name
			@model[mul_num][1][position+1] = token.name
			@model[mul_num][2][position+2] = token.name
			@model[mul_num][3][position+3] = token.name
			token.level = position+4
			token.status = "ready"
		elsif @model[mul_num][0][position] != nil
			new_position = @model[mul_num][0].length
			@model[mul_num][0][new_position] = token.name
			@model[mul_num][1][new_position+1] = token.name
			@model[mul_num][2][new_position+2] = token.name
			@model[mul_num][3][new_position+3] = token.name
			token.level = new_position+4
			token.status = "ready"
		end
	end

	def sumator_task_push(token, sum_num)
		position = [token.value.first.level, token.value.last.level].max
		if @model[sum_num][0][position] == nil
			@model[sum_num][0][position] = token.name
			@model[sum_num][1][position+1] = token.name
			token.level = position+2
			token.status = "ready"
		elsif @model[sum_num][0][position] != nil
			new_position = @model[sum_num][0].length
			@model[sum_num][0][new_position] = token.name
			@model[sum_num][1][new_position+1] = token.name
			token.level = position+2
			token.status = "ready"
		end
	end

	def show_work_model
		for i in 0..@model.length-1
			for j in 0..@model[i].length-1
				
				@model[i][j].each do |elm|
					print "[   ]"if elm == nil
					print "[#{elm}]"if elm != nil
				end
				print "\n"
			end
		end
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

#str = "x/z+2+4*x+b+g/sol/t2+r+m*n*32+y/f-1/2/3"
#str = "y+2+a+b-d*x*r+y/z+y/3+z/2"
#str = "2+2-a*b+c*d*k*l*m*n*n/h+t/2"
#str = "2+k+r+b+r+c+r*t+(b-c*2*3)"
# tasks = TreeB.new(str)
# array_of_tops = tasks.array_of_hash_tree
# array_of_vars = tasks.all_vars
# vector = VectorProcessor.new(array_of_tops, array_of_vars)
