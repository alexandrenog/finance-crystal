class Option
    property description : String, index : Int64 | Nil
    property sub_group : OptionGroup | Nil, action : Action | Nil
    def initialize(@description : String, @index : Int64)
    end
    def initialize(@description : String, @sub_group : OptionGroup)
    end
    def initialize(@description : String, @action : Action)
    end
    def to_s(io : IO)
        io << @description
    end 
    def self.cancel(desc : String)
        Option.new(desc, -1)
    end
    def is_cancel?
        @index.not_nil! == -1
    end
end