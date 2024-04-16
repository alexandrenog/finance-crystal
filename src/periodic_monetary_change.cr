require "yaml"

class PeriodicMonetaryChange
    include YAML::Serializable
    property value : MonetaryValue, interval_type : IntervalType, start_after : Int64
    property title : String
    def initialize(@value : MonetaryValue, @interval_type : IntervalType, @start_after : Int64, @title : String)
    end
    def to_s(io : IO)
        io << "#{@value} #{@interval_type}, starting in #{@start_after} days"
        if(!title.empty?)
            io << "\t -  " << @title 
        end
    end
    def applies_to?(day : Int64)
        return false if(day <= start_after)

        effective_day = day - start_after - 1

        case interval_type
        when IntervalType::MONTHLY
            return true if effective_day % 30 == 0
        when IntervalType::WEEKLY
            return true if effective_day % 7 == 0
        when IntervalType::DAILY
            return true
        when IntervalType::FIVEDAYS_A_WEEK
            return true if effective_day % 7 <= 5
        when IntervalType::TWODAYS_A_WEEK
            return true if effective_day % 7 <= 2
        end
        return false
    end
end

