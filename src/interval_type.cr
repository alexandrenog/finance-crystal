enum IntervalType
    MONTHLY
    WEEKLY
    DAILY
    FIVEDAYS_A_WEEK
    TWODAYS_A_WEEK

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
            io <<  "two days a week"
        end
    end
end

INCOME_INTERVALS_OPTS = OptionGroup.new([
    Option.new("Monthly",0),
    Option.new("Weekly",1),
    Option.new("Five days a Week",3)
])


EXPENSE_INTERVALS_OPTS = OptionGroup.new([
    Option.new("Monthly", 0),
    Option.new("Weekly", 1),
    Option.new("Daily", 2),
    Option.new("Five days a Week", 3),
    Option.new("Two days a Week", 4)
])