require "./console_read.cr"

class ActionPerformer
    def self.exec(action : Action, data : Data)
        case action
        when Action::CHANGE_CURRENT_BALANCE
            change_current_balance(data)
        when Action::ADD_PERIODIC_INCOME
            add_periodic_income(data)
        when Action::ADD_PERIODIC_EXPENSE
            add_periodic_expense(data)
        when Action::WATCH_PROSPECTIONS
            watch_prospections(data)
        when Action::LIST_PERIODIC_TRANSACTIONS
            list_periodic_transactions(data)
        end
        data.save
    end 
    def self.change_current_balance(data)
        new_balance = read_float("Insert New balance = $")
        data.current_value = MonetaryValue.from_float(new_balance)
    end
    def self.add_periodic_income(data)
        value = read_float("Insert Income Value = $")
        if index = INCOME_INTERVALS_OPTS.ask.index
            start_after = read_int("Start after N days = ")
            data.add_periodic_montary_changes PeriodicMonetaryChange.new(MonetaryValue.from_float(value), IntervalType.from_value(index), start_after)
        end
    end
    def self.add_periodic_expense(data)
        value = read_float("Insert Expense Value = $")
        if index = EXPENSE_INTERVALS_OPTS.ask.index
            start_after = read_int("Start after N days = ")
            data.add_periodic_montary_changes PeriodicMonetaryChange.new(MonetaryValue.from_float(value).negative, IntervalType.from_value(index), start_after)
        end
    end
    def self.watch_prospections(data)
        if screen = data.screen_reference
            screen.refresh_screen
            data.view_prospections
            watch_options =  OptionGroup.new([] of Option).with_cancel("Go Back")
            while option = watch_options.ask
                break if option.is_cancel?
                screen.refresh_screen
                data.view_prospections
            end
        end
    end
    def self.list_periodic_transactions(data)
        if screen = data.screen_reference
            screen.refresh_screen
            puts "\n" + data.list_monetary_changes
            watch_options =  OptionGroup.new([] of Option).with_cancel("Go Back")
            while option = watch_options.ask
                break if option.is_cancel?
                screen.refresh_screen
                puts "\n" + data.list_monetary_changes
            end
        end
    end
end
