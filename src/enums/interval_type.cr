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
    def to_option
        Option.new(self.to_text.capitalize, self.value)
    end
end