class Parcer

attr_reader :all_exeptions

  def initialize(string)
    @str = string
    analyze
  end

  def analyze
  	@location = "#{Rails.root}/public/parcer/parcer_log.txt"
  	File.open(@location, 'w') {|file| file.truncate(0) }
    if @str =~ /\w/
      expression = @str.split("") # разделение на символы
      expression.delete(" ") # удаление пробелов
      expr = expression
      first_sign_expression(expr)

      if expr.include?(")") || expr.include?("(")
        border_analyzer(expr)
        brackets_position(expr) #Проверка на правильност

      end


      sign_before_border?(expr)                # знак перед и после скобки
      checking_sign_in_expression(expr)        # проверка на правильность знаков в выражении
      checking_last_sign_in_expression(expr)   # проверка последнего знака в выражении
      checking_number_input(expr)              # проверка на правильный ввод чисел(поиск лишних точек)
      find_wrong_variable                      # проверка имени переменной на правильность
      var_before_border(expr)
    else
      File.open(@location, 'a'){|file| file.write "Error. Input expression!"}
    end
  end

  def first_sign_expression(expression)
    error_list = ["/","*"]
    File.open(@location, 'a') do |file|
    	error_list.each{|err| file.write("#{expression[0..2].join}..." +
                                   " - Неверный символ в начале выражения\n" + "^\n") if err.eql?(expression.first)}
	end
  end

  def border_analyzer(expression)
    array_of_exp = []
    i = 0
    k=0
    expression.each{|elm| array_of_exp << [elm, i] if elm =~ /[)(]/; i=i+1} # составление массива из найденных скобок и их позиций
    if array_of_exp.first[0] == ")"
      ind = array_of_exp.first[1]   # поинтер
      st = ind-4
      st = 0 if (ind - 4) < 0
      pointer = 7
      pointer = 7+(ind-4) if (ind-4) < 0
      File.open(@location, 'a') do |file|
        file.write "...#{expression[st..ind+4].join}..." + " - неверный элемент. Выражение в скобках не может начинаться с символа - ')' \n"
      	file.write(" "*pointer + "^\n")
  		end
      return false
    end

      if array_of_exp.flatten.count("(") > array_of_exp.flatten.count(")")
      File.open(@location, 'a'){|file| file.write("Не хватает - " + "')'" + " в #{expression.join} \n")}
    elsif array_of_exp.flatten.count("(") < array_of_exp.flatten.count(")")
      File.open(@location, 'a'){|file| file.write("Не хватает - " + "'('" + " в #{expression.join} \n")}
    end
    if expression.join.include?")("
      File.open(@location, 'a'){|file| file.write("Должен быть знак между скобками\n")}
    end
  end

  def error_parcer(arg, error_list) # метод перебора символов
    a = arg.join
    error_list.each do |err|
      if a.include?(err)
        array_a = a.split("")
        a_i = a.index(err)
        pointer = 7
        a_i-4 < 0 ? border_left = 0 : border_left = a_i-4
        pointer = 7+(a_i-4) if a_i-4 < 0
        File.open(@location, 'a') do |file|
        file.write(array_a[border_left..a_i+4].join.insert(0, '...').insert(-1, '...') + "\t" +
                 " - неверный символ #{err} \n")
        file.write(" "*pointer + "^\n")
      	end
        array_a.delete_at(a.index(err))
        a = array_a.join
        error_list << err
      end
    end
  end

  def sign_before_border?(expression)
    error_list = ["=(","*)","/)","+)","-)","()",")(","(*","(+","(/"]
    error_parcer(expression, error_list)
  end

  def checking_sign_in_expression(expression)
    error_list = ["+*","+/","++","-+","-*","-/",
                  "**","*+","*/","//","/*","/+"]
    error_parcer(expression, error_list)
  end

  def checking_last_sign_in_expression(expression)
    File.open(@location, 'a'){|file| file.write("Неправильный символ в конце выражения #{expression.last}\n")} if expression.last =~ /[-+*\\\/]/
  end

  def checking_number_input(expression)
    array = expression.join.split(/[^.\d]/) # выделение точек и чисел из последовательности
    array.each do |elm|
      File.open(@location, 'a'){|file| file.write("Неизвестный тип " + "#{elm}\n")} if elm.count(".") > 1
    end
  end

  def find_wrong_variable
    buf_array = []
    mod_array = []
    mod_array	<< @str.split("")
    mod_array.each do |array|
      c = array.join.split(/[^a-z.\d]/)
      c.each{|elm| buf_array.push(elm) if elm.include?(".") }
    end
    buf_array.each do |elm|
      if elm =~ /[a-z]/
        File.open(@location, 'a'){|file| file.write("Неверное имя переменной " + "#{elm} \n")}
      end
    end
  end

  def var_before_border(expression)
    exp = expression.join
    if exp =~ /(\w\()/
      buf = exp =~ /(\w\()/
      File.open(@location, 'a'){|file| file.write("Нет знака перед скобкой - " + expression[buf-2..buf+2].join+"\n")}
    end
  end

  def brackets_position(expression)
    br = expression.join.split(/[^)(]/).join.split("")
    for i in 0..br.length
      if br[i] == "("
        br[i] = "~"
        if br.index(")") != nil
          if br.index(")") > i
            br[br.index(")")] = "~"
          end
        end
      end
    end
    File.open(@location, 'a'){|file| file.write("Ошика в правелности ввода скобок в выражении #{expression.join} \n")} if br.include?(")")
  end

end

#string = "*1+5+c/2-)+/3.a/x"