class App
    property data : Data
    def initialize(@main_option_group : OptionGroup,  @data : Data)
        @info_row = InfoRow.new(@data)
    end

    def run
        @main_option_group.inquiry(self)
    end
    
    def refresh_screen(title = "")
        print "\33c\e[3J"
        @info_row.title = title
        print @info_row
    end
end