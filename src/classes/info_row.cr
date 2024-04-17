class InfoRow
    property data : Data
    property title : String = ""
    def initialize(@data : Data)
    end
    def to_s(io : IO)
        io << "#{I18n.t("label.current_balance")} = #{data.current_balance}"
        if !data.name.empty?
            io << "\t #{I18n.t("label.username")} = " + data.name
        end
        io << "\t\t #{I18n.t("label.date")} = #{today.to_s("%F")}"
        io << EOL
        if !title.empty?
            io << "[#{@title}]"
            io << EOL
            title = ""
        end
        io << EOL
    end
end