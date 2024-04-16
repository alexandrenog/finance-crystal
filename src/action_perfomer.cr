require "./console_read.cr"

class ActionPerformer
    def self.exec(action : Action, app : App)
        data = app.data
        case action
        when Action::CHANGE_CURRENT_BALANCE
            change_current_balance(data)
        when Action::ADD_PERIODIC_INCOME
            add_periodic_income(data)
        when Action::ADD_PERIODIC_EXPENSE
            add_periodic_expense(data)
        when Action::WATCH_PROSPECTIONS
            watch_prospections(data, app)
        when Action::LIST_PERIODIC_TRANSACTIONS
            list_periodic_transactions(data, app)
        end
        data.save
    end 
    def self.change_current_balance(data)
        new_balance = read_float("Insert New balance = $")
        data.current_balance = MonetaryValue.from_float(new_balance)
    end
    def self.add_periodic_income(data)
        value = MonetaryValue.from_float(read_float("Insert Income Value = $"))
        if index = INCOME_INTERVALS_OPTS.ask.index
            start_after = read_int("Start after N days = ")
            title = read_str("Give it a title ( _ for empty) = ").chomp
            title = "" if title == "_"
            data.add_periodic_montary_changes PeriodicMonetaryChange.new(value, IntervalType.from_value(index), start_after, title)
        end
    end
    def self.add_periodic_expense(data)
        value = MonetaryValue.from_float(read_float("Insert Expense Value = $")).negative
        if index = EXPENSE_INTERVALS_OPTS.ask.index
            start_after = read_int("Start after N days = ")
            title = read_str("Give it a title ( _ for empty) = ").chomp
            title = "" if title == "_"
            data.add_periodic_montary_changes PeriodicMonetaryChange.new(value, IntervalType.from_value(index), start_after, title)
        end
    end
    def self.watch_prospections(data, app)
        show_info(data.formatted_prospections, app)
    end
    def self.list_periodic_transactions(data, app)
        show_info(data.formatted_monetary_changes, app)
    end

    # auxiliary method (not an action)
    def self.show_info(content,app)
        app.refresh_screen
        puts content
        watch_options = OptionGroup::EMPTY
        while option = watch_options.ask
            break if option.is_cancel?
            app.refresh_screen
            puts content
        end
    end
end
