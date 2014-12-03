class TreeB

	attr_accessor :array_of_hash_tree, :all_vars

	def initialize(expression)
		@expression = expression
		@array_of_hash_tree = []
		@hash_of_brackets = {}
		@all_vars = []
		run_program
	end

	def run_program
		@counter_breckets = 1
		exp = partition_expr(@expression)
		exp = find_brackets(exp)
		exp_str = exp.join
		# Перенос минусов на право
		newstr = right_minus(exp_str)
		array_of_expr = newstr.split("-")
		array_sort = []
		# Перенос деления на право
		array_of_expr.each{|array| array_sort.push right_div(array)}
		array_sort.last.insert(0,"(").insert(-1,")")
		string_sorted_main = array_sort.join("-")
		# Модифицированное выражение
		# Очистка выражения от лишних скобок
		while string_sorted_main =~ /\(\w*\)/
			string_sorted_main =  fix_brackets(string_sorted_main)
		end
		# Цикл для выполнения модификации выражений в скобках
		@hash_of_brackets.each do |key, val|
			value = val
			value.slice!(0)
			value.slice!(-1)
			# Перенос минусов на право
			newstr = right_minus(value)
			array_of_expr = newstr.split("-")
			array_sort = []
			# Перенос деления на право
			array_of_expr.each{|array| array_sort.push right_div(array)}
			array_sort.last.insert(0,"(").insert(-1,")")
			string_sorted = array_sort.join("-")
			while string_sorted =~ /\(\w*\)/
				string_sorted =  fix_brackets(string_sorted)
			end
			@hash_of_brackets[key] = string_sorted
		end
		return_brackets_in_exp	
		
		while string_sorted_main =~ /br\d/
			string_sorted_part = partition_expr(string_sorted_main)
			string_sorted_main = find_brackets_var(string_sorted_part)
		end

		@counter_1 = 1
		@counter_2 = 1
		cut_string = partition_expr(string_sorted_main) 	#Array. Переменные и операторы
		priorities = set_priority(cut_string) 			#Array. Приоритеты

		# Запуск цикла для построения дерева

		cycle_exp = stage_builder(priorities,cut_string)
		while cycle_exp =~ /[*+\\\/-]/
			while cycle_exp =~ /\(\w*\)/
				cycle_exp = fix_brackets(cycle_exp)
			end
			cut_string = partition_expr(cycle_exp)
			priorities = set_priority(cut_string)
			cycle_exp = stage_builder(priorities,cut_string)
		end
		@array_of_hash_tree
		vars = partition_expr(@expression)
		vars.each {|elm| @all_vars << elm if elm !~ /[\(\\)*+\\\/-]/ }
	end

	def stage_builder(priority_list,expression)
		prior_str = priority_list.join
		hash = {}
		change_exp = expression
		exaples = ["848","727","919"]
		while (prior_str.include?("848") || prior_str.include?("727") || prior_str.include?("919"))
			exaples.each do |exm| 
				if prior_str.index(exm) != nil
					p = prior_str.index(exm)
					prior_str[p] = "0"
					prior_str[p+1] = "0"
					prior_str[p+2] = "0"
					hash["vr"+@counter_2.to_s] = expression[p..p+2].join
					change_exp[p] = "v"
					change_exp[p+1] = "r"
					change_exp[p+2] = @counter_2.to_s
					@counter_2 = @counter_2 + 1
				end
			end
		end
		prior_str
		@array_of_hash_tree << hash
		return change_exp.join
	end

	def find_brackets_var(expression)
		@hash_of_brackets
		exp = expression
		@hash_of_brackets.each do |key, val|
			if exp.include?(key)
				index = exp.index(key)
				exp[index] = val
			end
		end
		return exp.join
	end

	def return_brackets_in_exp
		@hash_of_brackets.each do |key, val|
			if val[0] != "(" || val[-1] != ")"
				@hash_of_brackets[key] = "(" + val + ")"
			end
		end
	end

	def fix_brackets(expression)
		if expression =~ /\(\w*\)/
			point = expression =~ /\(\w*\)/
			exp = expression.split("")
			exp.delete_at(point)
			while exp[point] != ")"
				point = point + 1
			end
			exp.delete_at(point)
			return exp.join
		else
			return false
		end
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

	def set_priority(expression)
		exp = expression
		prior_exp = Array.new(exp.length) { |i| i = "_" }
		index_exp = []
		for i in 0..exp.length-1
			if exp[i] == "*"
				prior_exp[i] = 4
				index_exp << i
			elsif exp[i] == "/"
				prior_exp[i] = 2
				index_exp << i
			elsif (exp[i] == "-" || exp[i] == "+")				
				prior_exp[i] = 1
				index_exp << i
			elsif (exp[i] == "(" || exp[i] == ")")
				prior_exp[i] = 5
			end
		end
		for i in index_exp
			if prior_exp[i] == 4
				if prior_exp[i-1] != 5
					prior_exp[i-1] = 8
				end
				if prior_exp[i+1] != 5
					prior_exp[i+1] = 8
				end
			elsif prior_exp[i] == 2
				if (prior_exp[i-1] != 5 && prior_exp[i-1] != 4 && prior_exp[i-1] != 8 )
					prior_exp[i-1] = 7
				end
				if (prior_exp[i+1] != 5 && prior_exp[i+1] != 4 && prior_exp[i+1] != 8)
					prior_exp[i+1] = 7
				end
			elsif prior_exp[i] == 1
				if (prior_exp[i+1] != 5 && prior_exp[i+1] != 4	&& prior_exp[i+1] != 2 && prior_exp[i+1] != 8 &&  prior_exp[i+1] != 7)
					prior_exp[i+1] = 9
				end
				if (prior_exp[i-1] != 5 && prior_exp[i-1] != 4	&& prior_exp[i-1] != 2 && prior_exp[i-1] != 8 && prior_exp[i-1] != 7)
					prior_exp[i-1] = 9
				end			
			end
		end
		@counter_1 += 1
		return prior_exp
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

	def right_minus(expression)
		exp = expression
		exp = exp.split("")
		new_array = Array.new
		new_array_other = exp
		i_count = 0
		for i in 0..exp.length
			if exp[i] == "-"
				i_count = i+1
				new_array.push(exp[i])
				new_array_other[i] = "~"

				while exp[i_count] =~ /[^-+]/
					new_array.push(exp[i_count])
					new_array_other[i_count] = "~"
					i_count=i_count+1
				end
			end
		end
		
		new_array_other.delete("~")
		
		new_array = new_array.join.split("-")
		new_array.delete("")
		new_array.sort!{|x,y| y.length <=> x.length}

		new_array_other = new_array_other.join.split("+")
		new_array_other.delete("")
		new_array_other.sort!{|x,y| y.length <=> x.length}
		
		return str = new_array_other.join("+") + "-" + new_array.join("+")
	end

	def right_div(expression)
		array_of_div_vars = []
		array_of_vars = []
		exp = expression.split("+")
		exp
		buf_array = []
		exp.each do |elm|
			if elm =~ /[\\\/]/ && elm =~ /[*]/
				array_of_div_vars.push(elm.split("*"))
			else
				array_of_vars.push(elm)
			end
		end
		array_of_div_vars.each do |arr_elm|
		lockal_buf = []
			arr_elm.each do |elm|
				if elm.index("/")
					 lockal_buf.push elm[0..elm.index("/")-1], elm[elm.index("/")..-1]
				else
					lockal_buf.push(elm)
				end
			end
		lockal_buf
		v1 = []
		v2 = []
		lockal_buf.each do |elm|
			if elm[0] == "/"
				v2.push elm
			else
				v1.push elm
			end
		end
		var1 = v1.join("*")
		var2 = "(" + v2.join[1..-1] + ")"
		var2.gsub!(/[\\\/]/,"*")
		buf_array.push [var1,var2].join("/")
		end
		array_of_div_vars = buf_array
		another_vars_buffer = []
		array_of_vars.each do |elm|
			if elm =~ /[\\\/]/
				var1 = elm[0..elm.index("/")]
				var2 = "(" + elm[elm.index("/")+1..-1].gsub(/[\\\/]/, "*") + ")"
				another_vars_buffer.push [var1,var2].join
			else
				another_vars_buffer.push elm
			end
		end
		array_of_vars = another_vars_buffer
		res = array_of_div_vars + array_of_vars
		return res.join("+")
	end
end