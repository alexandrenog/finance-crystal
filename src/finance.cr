require "./*"

GO_BACK = "Go Back"

class App
    property data : Data
    def initialize(@main_option_group : OptionGroup)
        @data = read_or_create_data
        @info_row = InfoRow.new(@data)
    end

    def read_or_create_data
        begin
            return Data.from_yaml(File.read(DATA_FILE))
        rescue
            return Data.new(name: read_str("Insert Username: ")).save
        end
    end

    def run
        @main_option_group.inquiry(self)
    end
    
    def refresh_screen
        print "\33c\e[3J\n"
        puts @info_row
    end
    
end


App.new(
    OptionGroup.new([
        Option.new("Watch Prospections", Action::WATCH_PROSPECTIONS),
        Option.new("Change Current Balance", Action::CHANGE_CURRENT_BALANCE),
        Option.new("Add Periodic Income/Expense", 
            OptionGroup.new([
                Option.new("Add Periodic Income", Action::ADD_PERIODIC_INCOME),
                Option.new("Add Periodic Expense", Action::ADD_PERIODIC_EXPENSE)
            ]).with_cancel(GO_BACK)
        ),
        Option.new("List Periodic Transactions", Action::LIST_PERIODIC_TRANSACTIONS)
    ]).with_cancel("Exit")
).run()

