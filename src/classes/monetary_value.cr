require "yaml"

class MonetaryValue
    include YAML::Serializable
    property value_in_cents : Int64, positive : Bool
    def initialize(@value_in_cents : Int64, @positive : Bool = true)
    end
    def self.from_float(float_value : Float64)
        MonetaryValue.new((float_value*100).to_i64)
    end
    def to_s(io : IO)
        actual_value = (@value_in_cents / 100).to_i64
        cents_part = @value_in_cents % 100
        io << "#{@positive ? "" : "-"}#{I18n.t("label.money_sign")}#{actual_value}#{I18n.t("label.decimal_separator")}#{"%02d" % cents_part}"
    end
    def self.zero
        MonetaryValue.new(0)
    end
    def negative
        @positive = false
        self
    end
    def signed_cents
        self.value_in_cents * (self.positive ? 1 : -1)
    end
    def +(other : MonetaryValue) 
        sum_in_cents = self.signed_cents + other.signed_cents
        MonetaryValue.new(sum_in_cents.abs, sum_in_cents.positive?)
    end
    def <=>(other : MonetaryValue)
        self.signed_cents <=> other.signed_cents
    end
end