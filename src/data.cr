require "./monetary_value.cr"
require "yaml"

DATA_FILE = "data.yaml"

class Data
    property current_day : Int64 = 1
    property current_value : MonetaryValue
    property name : String
    property periodic_montary_changes : Array(PeriodicMonetaryChange)
    property screen_reference : Screen | Nil
    def initialize(@current_value : MonetaryValue = MonetaryValue.zero, @name : String = "")
        @periodic_montary_changes = [] of PeriodicMonetaryChange
    end
    def occurrences_in(day : Int64)
        @periodic_montary_changes.select{|periodic_money_change| periodic_money_change.applies_to?(day)}
    end
    def view_prospections()
        print "\n"
        values_in_120_days = [@current_value]
        ((current_day+1)..(current_day+120-1)).each do |day|
            day_value = values_in_120_days.last
            occurrences = occurrences_in(day)
            occurrences.each do |money_change|
                day_value += money_change.value
            end     
            values_in_120_days << day_value
        end

        puts values_in_120_days.each_slice(7).map_with_index{|e,i| "Day #{(i*7)+1}: " + e.map(&.to_s).join(", ")}.join("\n")
    end
    def list_monetary_changes
        periodic_montary_changes.map(&.to_s).join("\n")
    end
    def self.from_dao(dao : DataDAO)
        data = Data.new(dao.current_value, dao.name.not_nil!)
        data.periodic_montary_changes = dao.periodic_montary_changes
        data.current_day = dao.current_day
        return data
    end
    def to_dao
        DataDAO.from_object(self)
    end
    def add_periodic_montary_changes (change : PeriodicMonetaryChange)
        periodic_montary_changes << change
        periodic_montary_changes.sort_by! &.value.signed_cents
    end
    def save
        File.write(DATA_FILE, self.to_dao.to_yaml)
        self
    end
end

class DataDAO
    include YAML::Serializable
    property current_day : Int64 = 1
    property current_value : MonetaryValue
    property name : String
    property periodic_montary_changes : Array(PeriodicMonetaryChange)
    def initialize(@current_value : MonetaryValue = MonetaryValue.zero, @name : String = "")
        @periodic_montary_changes = [] of PeriodicMonetaryChange
    end

    def self.from_object(data : Data)
        dao = DataDAO.new
        dao.current_day = data.current_day
        dao.current_value = data.current_value
        dao.name = data.name
        dao.periodic_montary_changes = data.periodic_montary_changes
        return dao
    end
end