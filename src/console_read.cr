
def read_str(label : String | Nil = nil )
    s = nil
    while s == nil
        begin 
            if label
                print label
            end
            s = gets.not_nil!
        rescue
        end
    end
    s.not_nil!
end
def read_int(label = nil)
    num = nil
    until num
        str = read_str(label)
        begin 
            num = str.to_i64
        rescue
        end
    end
    num.not_nil!
end

def read_float(label = nil) : Float64
    num = nil
    until num
        str = read_str(label)
        begin 
            num = str.to_f64
        rescue
        end
    end
    num.not_nil!
end