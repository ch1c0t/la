module App
  module Screen
    module_function

    def clear
      print "\e[H\e[2J"
    end
  end

  module InsertApp
    module_function

    def run
      Screen.clear

      while gets
        if $_.start_with? ':'
          command = $_.strip
        else
        end
      end
    end
  end

  module CLI
    module_function
    def run
      case ARGV[0]
      when 'insert'
        InsertApp.run
      when 'search'
        SearchApp.run
      end
    end
  end
end
