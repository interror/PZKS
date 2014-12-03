class Commute

	attr_reader :res_sort, :string, :res_shuffle

	def initialize(string)
		@string = string
		@res_shuffle = []
		options1 = "-b"
		run_program(options1)
	end

	def run_program(options1)
		@hash_of_brackets = {}
		@counter_breckets = 1
		exp_array = partition_expr(@string)
		exp_array = find_brackets(exp_array)
		exp_array = create_tokens(exp_array)
		str = exp_array.join
		# Sorting breckets 
		if options1 == "-b"
			breckets_sort
		end

		while str =~ /br\d/
			for i in 0..exp_array.length-1
				if exp_array[i].class == Array
					for j in 0..exp_array[i].length-1
						exp_array[i][j] = partition_expr(exp_array[i][j])
					end
					exp_array[i].flatten!
				end
			end
			exp_array = find_brackets_var(exp_array)
			str = exp_array.join
		end
		array_of_tokens = token_fix_after_brk(exp_array)
		array_of_weights = weight_of_operation(array_of_tokens) # ARRAY OF WEIGHTS EXAMPLE [0,2,4,3]
		array_of_tokens = operations_fix(array_of_tokens) # ARRAY OF TOKKENS EXAMPLE [["+", "a"], ["+", "b1"]["-", "2", "*", "3"]]
		super_array = []
		for i in 0..array_of_weights.length-1
			super_array << [array_of_weights[i], array_of_tokens[i].join]
		end
		super_array
		super_array.sort!{|x,y| x.first <=> y.first } # END RESULT OF SORT
		# First STRING OUT
		string_out_first = super_array.map{|elm| elm.last }.join
		string_out_first.slice!(0) if string_out_first[0] == "+"

		@res_sort = string_out_first
		
		shuffle_tokens(super_array)

	end


	def shuffle_tokens(super_array)
	shuffle_hash = {}
	start = super_array[0].first
	buf_array = []
		super_array.each do |elm|
			if elm.first == start
				buf_array << elm.last
			elsif elm.first > start
				shuffle_hash[start] = buf_array
				start = elm.first
				buf_array = []
				buf_array << elm.last
			end
		shuffle_hash[start] = buf_array
		end
		
		find_max_num_of_shuffle = []
		shuffle_hash.each do |key, val|
			if key > 0
				n = val.length
				buf = 1
				(1..n).to_a.each {|val| buf = buf * val}
				find_max_num_of_shuffle << buf if buf != 1
			end
		end


		max_num_of_shufle = find_max_num_of_shuffle.inject {|sum,val| sum *= val}
		max_num_of_shufle = 1 if max_num_of_shufle == nil
		shuffle_hash[start] = buf_array
		res_shuffle_length = 0

		while max_num_of_shufle > res_shuffle_length
			output_string = []
			shuffle_hash.each do |key,val|
				if key > 0
					val.shuffle!
				end
			end
			shuffle_hash.each_value{|val| output_string << val }
			output_string.flatten!
			output_string = output_string.join
			output_string.slice!(0) if output_string[0] == "+"			
			@res_shuffle << output_string
			@res_shuffle.uniq!
			res_shuffle_length = @res_shuffle.length
		end
	end

	def breckets_sort
		@hash_of_brackets.each do |key, val|
			string_brk = val[1..-2]
			array_brk = partition_expr(string_brk)
			array_brk = create_tokens(array_brk)
			exp_array = array_brk
			str = exp_array.join

			while str =~ /br\d/
			for i in 0..exp_array.length-1
				if exp_array[i].class == Array
					for j in 0..exp_array[i].length-1
						exp_array[i][j] = partition_expr(exp_array[i][j])
					end
					exp_array[i].flatten!
				end
			end
			exp_array = find_brackets_var(exp_array)
			str = exp_array.join
		end
		array_of_tokens = token_fix_after_brk(exp_array)
		array_of_weights = weight_of_operation(array_of_tokens)
		array_of_tokens = operations_fix(array_of_tokens)
		
		super_array = []
		for i in 0..array_of_weights.length-1
			super_array << [array_of_weights[i], array_of_tokens[i].join]
		end
		super_array.sort!{|x,y| x.first <=> y.first }
		
		string_out = super_array.map{|elm| elm.last }.join
		string_out.slice!(0) if string_out[0] == "+"
		@hash_of_brackets[key] = "(" + string_out + ")"
		end
	end

	def operations_fix(array_of_tokens)
		array_exp = array_of_tokens
		while array_exp.include?("+")
				index_plus = array_exp.index("+")
				array_exp[index_plus+1].insert(0,"+")
				array_exp.delete_at(index_plus)
			end
			while array_exp.include?("-")
				index_minus = array_exp.index("-")
				array_exp[index_minus+1].insert(0,"-")
				array_exp.delete_at(index_minus)
			end
			array_exp[0].insert(0,"+")
		return array_exp
	end

	def weight_of_operation(array)
		array_of_weights = []
		for i in 0..array.length-1
			if array[i].class == Array
				weight = (array[i].count("*")*2) + (array[i].count("+")*1) + (array[i].count("-")*1) + (array[i].count("/")*4)
				array_of_weights << weight
			end
		end
		return array_of_weights
	end

	def create_tokens(expression)
		token_buffer = []
		final_array = []
		for i in 0..expression.length-1
			if expression[i] =~ /[+-]/
				final_array << token_buffer
				final_array << expression[i]
				token_buffer = []
			else
				token_buffer << expression[i]
			end
		end
		final_array << token_buffer
		return final_array
	end

	def token_fix_after_brk(exp_array)
			for i in 0..exp_array.length-1
				if exp_array[i].class == Array
					for j in 0..exp_array[i].length-1
						exp_array[i][j] = partition_expr(exp_array[i][j])
					end
					exp_array[i].flatten!
				end
			end
			return exp_array
	end

	def partition_expr(expression)
		array_of_elm =  expression.split("")
		buffer_for_variables = []
		array_expression = []
		for i in 0..array_of_elm.length - 1
			if array_of_elm[i] =~ /[*+\\\/()-]/
				array_expression << buffer_for_variables.join
				buffer_for_variables = []
				array_expression << array_of_elm[i]
			elsif array_of_elm[i] =~ /[\w.]/
				buffer_for_variables << array_of_elm[i]
			end
		end
		array_expression << buffer_for_variables.join
		array_expression.delete("")
		return array_expression
	end

	def find_brackets(expression)
		exp = expression
		while exp.include?("(")
			br_counter = 0
			priority_list = []
			for i in 0..exp.length-1
				if exp[i] == "("
					br_counter = br_counter + 1
					priority_list << br_counter
				elsif exp[i] == ")"
					priority_list << br_counter
					br_counter = br_counter - 1
				else
					priority_list << br_counter
				end
			end
			max_elm = priority_list.max
			index_elm1 = priority_list.join =~ /#{max_elm}/
			counter = 0
			i = index_elm1
			while priority_list[i] == max_elm
				counter = counter + 1
				i = i + 1
			end
			index_elm2 = index_elm1 + (counter-1)
			@hash_of_brackets["br" + @counter_breckets.to_s] = exp[index_elm1..index_elm2].join
			exp.slice!(index_elm1..index_elm2)
			exp.insert(index_elm1, "br" + @counter_breckets.to_s)
			@counter_breckets = @counter_breckets + 1
		end
		return exp
	end

	def find_brackets_var(expression)
		@hash_of_brackets
		exp = expression
		@hash_of_brackets.each do |key, val|
			exp.each do |elm|
				if elm.include?(key)
					index = elm.index(key)
					elm[index] = val
				end
			end
		end
		return exp
	end

end


#string = "a+(b+c+d*e)-m*n-f/k+3*l*v-(w+o+z)-g/h/5+(4/g+2-t*y)"
#string = "x/z+2+4*x+b+g/s/t+r+m*n*3+y/f-h/u/q+(1-3+4+3+4)"

#commute_operation = Commute.new(string, ARGV[0])
#p commute_operation.string
#p commute_operation.res_sort
#puts commute_operation.res_shuffle