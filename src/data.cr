require "./monetary_value.cr"
require "yaml"


class Data
    include YAML::Serializable
    property current_balance : MonetaryValue
    property name : String
    property periodic_montary_changes : Array(PeriodicMonetaryChange)
    def initialize(@current_balance : MonetaryValue = MonetaryValue.zero, @name : String = "")
        @periodic_montary_changes = [] of PeriodicMonetaryChange
    end
    def occurrences_in(day : Time)
        @periodic_montary_changes.select{|periodic_money_change| periodic_money_change.applies_to?(day)}
    end
    def formatted_prospections
        months=[] of String
        values_per_month = Array(Array(Tuple(Time,MonetaryValue))).new
        date = date_in_n_days(1)
        Consts::PROSPECTIONS_MONTHS.times do |i|
            values_per_month << Array(Tuple(Time,MonetaryValue)).new
            if i == 0
                values_per_month[0] << {today, @current_balance}
                next if date_in_n_days(1).month != today.month
            else 
                date = first_day_of_n_month_since_day(today,i)
            end 
            last_day = last_day_of_n_month_since_day(today, i)
            format_prospections_month(values_per_month, date, last_day)
        end
        
        values_per_month.map{ |values_per_day| # 0..Consts::PROSPECTIONS_MONTHS-1 months list -> 1..28~31 day list
            values_per_day.each_slice(7).map{ |array_of_tuple| # 1..28~31 days list -> 7 days list
                first_of_7_days = array_of_tuple.first[0]
                all_7_days_values = array_of_tuple.map{ |tuple| tuple[1].to_s }.join(", ")
                "Day #{first_of_7_days.to_s("%F")}: #{all_7_days_values}" 
            }.join("\n")
        }.join("\n\n")
    end
    def format_prospections_month(values_per_month, date, last_day)
        while date <= last_day
            value = (!values_per_month[-1].empty?) ? values_per_month[-1].last[1] : values_per_month[-2].last[1]
            occurrences_in(date).each do |money_change|
                value += money_change.value
            end     
            values_per_month[-1] << {date, value}
            date = date.succ
        end
    end
    def formatted_monetary_changes
        sort_periodic_montary_changes
        periodic_montary_changes.map(&.to_s).join("\n")
    end
    def add_periodic_montary_changes (change : PeriodicMonetaryChange)
        periodic_montary_changes << change
        sort_periodic_montary_changes
    end
    def sort_periodic_montary_changes
        periodic_montary_changes.sort_by! &.value.signed_cents
    end
    def save
        File.write(Consts::DATA_FILE, self.to_yaml)
        self
    end
end
