class TreeBuilderController < ApplicationController
require 'treeb'
require 'parcer'
require 'commuter'
require 'vector_processor'
require 'token'

  def build
  	@string = params["str"]
  	if @string =~ /\w/
	  	new_tree = TreeB.new(@string)
		#puts new_tree.array_of_hash_tree
		puts gon.hashes = new_tree.array_of_hash_tree
		gon.hashes = new_tree.array_of_hash_tree.map{|elm| elm.to_a }
		
		for i in 0..gon.hashes.length-1
			for j in 0..gon.hashes[i].length-1
				buf_var = gon.hashes[i][j][1]
				index_var = gon.hashes[i][j][1].index(/[*+\\\/-]/)
				buf_var = buf_var.split(/[*+\\\/-]/)
				buf_var = buf_var.insert(1,(gon.hashes[i][j][1])[index_var])
				gon.hashes[i][j][1] = buf_var
			end
		end
		gon.first_vars = new_tree.all_vars
	end
  end

  def index
  	@string = params['str']
  end

  def parcer
  	@location = "#{Rails.root}/public/parcer/parcer_log.txt"
  	@string = params['myform']['field']
  	new_parcer = Parcer.new(@string)
  end

  def commuter 
  	@string = params['string']
  	commute_operation = Commute.new(@string)
  	@out_res_str = commute_operation.res_sort
  	@out_res_shuffle = commute_operation.res_shuffle
  end

  def bracketing
    @string = params['str']
    if @string =~ /\(/
      @out_result = []
      @out_result[0] = "ERROR! Wrong expression"
    else
      location = "#{Rails.root}/public/jars/"
      args1= @string
      args2 = "1"
      Dir.chdir("#{location}") do
        retResult  = system("java -jar PZKS.jar #{args1} #{args2} > out.txt")
      end
      @out_result = ""
      File.open("#{location}out.txt", "r") do |f|
        f.each_line do |line|
          @out_result = @out_result + line
        end
      end
      @out_result = @out_result.split(";")
      for i in 0..@out_result.length-1
        @out_result[i] = @out_result[i].split(".0").join
      end
      @out_result.delete_at(-1)
    end
  end

  def vector_processor
    @string = params["str"]
    tasks = TreeB.new(@string)
    array_of_tops = tasks.array_of_hash_tree
    array_of_vars = tasks.all_vars
    vector = VectorProcessor.new(array_of_tops, array_of_vars)
    gon.vector_diagram = vector.model
    max = vector.model.map {|elm| elm.length}
    max = max.max
    p gon.array_height = max
    p gon.array_width = vector.model.length
  end

end
