enum IntervalType
    MONTHLY
    WEEKLY
    DAILY
    FIVEDAYS_A_WEEK
    TWODAYS_A_WEEK
    ONCE

    def to_s(io : IO)
        case self
        when MONTHLY
            io << "monthly"
        when WEEKLY
            io << "weekly"
        when DAILY
            io << "daily"
        when FIVEDAYS_A_WEEK
            io << "five days a week"
        when TWODAYS_A_WEEK
            io << "two days a week"
        when ONCE
            io << "once"
        end
    end
end

def intervalTypeOption(type : IntervalType)
    Option.new(type.to_s.capitalize, type.value)
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