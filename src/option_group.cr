require "./option.cr"
class OptionGroup
    EMPTY = OptionGroup.new([] of Option).with_cancel("Go Back")
    property options : Array(Option), title : String
    def initialize(@options : Array(Option), @title : String = "") 
        @options.each_with_index do |opt,i| 
            opt.index ||= i
         end
    end
    def to_s(io : IO)
         io << @options.map_with_index{|option,i| " - #{i+1}. #{option.to_s}"}.join("\n")
         io << EOL
    end
    def include?(index : Int)
        index >= 0 && index < @options.size
    end
    def choose(index : Int)
        @options[index]
    end
    def with_cancel(desc : String)
        @options << Option.cancel(desc)
        self
    end

    def ask
        puts @title if !@title.empty?
        puts self
        print "Select Option: "
        opt_index = read_int - 1
        while !self.include?(opt_index) 
            print "Select Option: "
            opt_index = read_int - 1
        end
        self.choose(opt_index)
    end

    def inquiry(app)
        current_option_group = self
        stack = [current_option_group]
        until stack.empty?
            # set options
            current_option_group = stack.last

            # CLI
            app.refresh_screen
            selectedOpt = current_option_group.ask

            # Option Evaluation
            if selectedOpt.is_cancel?
                stack.pop
            elsif action = selectedOpt.action
                ActionPerformer.exec(action, app)
            elsif sub_group = selectedOpt.sub_group
                current_option_group = sub_group
                stack << current_option_group
            else
                raise "error"
            end
        end
    end
end