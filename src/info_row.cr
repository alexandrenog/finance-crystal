class InfoRow
    property data : Data
    def initialize(@data : Data)
    end
    def to_s(io : IO)
        io << "Current Balance = #{data.current_balance}"
        if !data.name.empty?
            io << "\t Username = " + data.name
        end
        io << EOL
    end
end