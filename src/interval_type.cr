enum IntervalType
    MONTHLY
    WEEKLY
    DAILY
    FIVEDAYS_A_WEEK
    TWODAYS_A_WEEK
    ONCE

    def to_text
        I18n.t("interval_type."+self.to_s.downcase)
    end
end

def intervalTypeOption(type : IntervalType)
    Option.new(type.to_text.capitalize, type.value)
end