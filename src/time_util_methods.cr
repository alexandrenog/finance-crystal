
struct Time
    def succ
       self + Time::Span.new(days: 1)
    end
  end
  
def days_range(date : Time, days : Int64)
    date...(date+Time::Span.new(days: days))
end

def today
    Time.local(Time::Location.load(Consts::TIME_LOCATION)).at_beginning_of_day
end

def date_in_n_days (n : Int64)
    today + Time::Span.new(days: n)
end

def parse_day(str : String)
    Time.parse_utc(str, "%F").to_local_in(Time::Location.load(Consts::TIME_LOCATION))
end

def heuristically_the_same_day(date,target_day_date)
    return true if date.day == target_day_date.day
    end_of_month_day = date.at_end_of_month.day
    return date.day == end_of_month_day && end_of_month_day < target_day_date.day
end

def first_day_of_n_month_since_day(initial_date : Time, n : Int64)
    first_day_of_month = initial_date.at_beginning_of_month 
    n.times{
        first_day_of_month = (first_day_of_month + Time::Span.new(days: 31)).at_beginning_of_month
    }
    first_day_of_month
end
def last_day_of_n_month_since_day(initial_date : Time, n : Int64)
    first_day_of_n_month_since_day(initial_date,n).at_end_of_month.at_beginning_of_day
end