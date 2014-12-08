class Token

	attr_accessor :name, :value, :level, :status, :weight

	def initialize(str, value, level)
		@name = str
		@value = value
		@level = level
		@status = "wait"
		@weight = 0
	end

	def puts_name
		puts @name
	end

	def puts_value
		puts @value
	end

	def split_value
		if @value =~ /[-+\\\/*]/
			index = @value =~ /[-+\\\/*]/
			@value = [@value[0..index-1], @value[index], @value[index+1..-1]]
		end
	end

end
