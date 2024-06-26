require "yaml"

class PeriodicMonetaryChange
    include YAML::Serializable
    property value : MonetaryValue
    property interval_type : IntervalType
    property title : String
    property start_at : Time
    def initialize(@value : MonetaryValue, @interval_type : IntervalType, @start_at : Time, @title : String)
    end
    def to_s
        self.to_text
    end
    def to_text(index : Int | Nil = nil)
        text = "\t" 
        if indexNotNil = index
            text += "#{indexNotNil}. "
        end
        text+="#{@value} #{@interval_type.to_text}, #{@start_at > today ? I18n.t("label.starts") : I18n.t("label.started")} #{I18n.t("label._on")} #{@start_at.to_s("%F")}"
        if(!title.empty?)
            text+= "\t -  " + @title 
        end
    end
    def applies_to?(day : Time)
        return false if(day < @start_at)

        day_difference = (day - @start_at).days

        case interval_type
        when IntervalType::MONTHLY
            return true if heuristically_the_same_day(day, @start_at)
        when IntervalType::WEEKLY
            return true if day_difference % 7 == 0
        when IntervalType::DAILY
            return true
        when IntervalType::FIVEDAYS_A_WEEK
            return true if day_difference % 7 <= 5
        when IntervalType::TWODAYS_A_WEEK
            return true if day_difference % 7 <= 2
        when IntervalType::ONCE
            return true if day_difference == 0
        end
        return false
    end
end

