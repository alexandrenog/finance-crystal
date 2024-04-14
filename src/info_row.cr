class InfoRow
    property data : Data
    def initialize(@data : Data)
    end
    def to_s(io : IO)
        str = "Current Value = #{data.current_value}"
        if !data.name.empty?
            str += "\t Username = " + data.name
        end
        io << str
    end
end