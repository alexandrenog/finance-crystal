require "./monetary_value.cr"
require "yaml"

DATA_FILE = "data.yaml"

class Data
    include YAML::Serializable
    property current_day : Int64 = 1
    property current_balance : MonetaryValue
    property name : String
    property periodic_montary_changes : Array(PeriodicMonetaryChange)
    def initialize(@current_balance : MonetaryValue = MonetaryValue.zero, @name : String = "")
        @periodic_montary_changes = [] of PeriodicMonetaryChange
    end
    def occurrences_in(day : Int64)
        @periodic_montary_changes.select{|periodic_money_change| periodic_money_change.applies_to?(day)}
    end
    def formatted_prospections()
        values_in_120_days = [@current_balance]
        ((current_day+1)..(current_day+120-1)).each do |day|
            day_value = values_in_120_days.last
            occurrences_in(day).each do |money_change|
                day_value += money_change.value
            end     
            values_in_120_days << day_value
        end
        values_in_120_days.each_slice(7).map_with_index{|e,i| "Day #{(i*7)+1}: " + e.map(&.to_s).join(", ")}.join("\n")
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
        File.write(DATA_FILE, self.to_yaml)
        self
    end
end
