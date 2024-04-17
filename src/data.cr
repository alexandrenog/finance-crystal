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
    def formatted_prospections()
        values_in_119_days = [@current_balance] # 119 days = 17 weeks
        days_range(date_in_n_days(1), 118).each do |day|
            day_value = values_in_119_days.last
            occurrences_in(day).each do |money_change|
                day_value += money_change.value
            end     
            values_in_119_days << day_value
        end
        values_in_119_days.each_slice(7).map_with_index{|e,i| "Day #{date_in_n_days(i*7).to_s("%F")}: " + e.map(&.to_s).join(", ")}.join("\n")
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
