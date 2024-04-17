class InfoRow
    property data : Data
    property title : String = ""
    def initialize(@data : Data)
    end
    def to_s(io : IO)
        io << "Current Balance = #{data.current_balance}"
        if !data.name.empty?
            io << "\t Username = " + data.name
        end
        io << "\t\t Date = #{today.to_s("%F")}"
        io << EOL
        if !title.empty?
            io << "[#{@title}]"
            io << EOL
            title = ""
        end
        io << EOL
    end
end