enum IntervalType
    MONTHLY
    WEEKLY
    DAILY
    FIVEDAYS_A_WEEK
    TWODAYS_A_WEEK
    ONCE

    def to_text
        case self
        when MONTHLY
            "monthly"
        when WEEKLY
            "weekly"
        when DAILY
            "daily"
        when FIVEDAYS_A_WEEK
            "five days a week"
        when TWODAYS_A_WEEK
            "two days a week"
        when ONCE
            "once"
        else
            raise("wont happen :)")
        end
    end
end

def intervalTypeOption(type : IntervalType)
    Option.new(type.to_text.capitalize, type.value)
end
INCOME_INTERVALS_OPTS = OptionGroup.new([
    intervalTypeOption(IntervalType::ONCE),
    intervalTypeOption(IntervalType::MONTHLY),
    intervalTypeOption(IntervalType::WEEKLY),
    intervalTypeOption(IntervalType::FIVEDAYS_A_WEEK)
], "This transaction happens:")


EXPENSE_INTERVALS_OPTS = OptionGroup.new([
    intervalTypeOption(IntervalType::ONCE),
    intervalTypeOption(IntervalType::MONTHLY),
    intervalTypeOption(IntervalType::WEEKLY),
    intervalTypeOption(IntervalType::DAILY),
    intervalTypeOption(IntervalType::FIVEDAYS_A_WEEK),
    intervalTypeOption(IntervalType::TWODAYS_A_WEEK)
], "This transaction happens:")