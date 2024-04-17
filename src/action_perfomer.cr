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
        new_balance = read_float(I18n.t("insert.new_balance"))
        data.current_balance = MonetaryValue.from_float(new_balance)
    end
    def self.add_periodic_income(data)
        title = read_str(I18n.t("insert.title")).chomp
        title = "" if title == "."
        if index = INCOME_INTERVALS_OPTS.ask.index
            start_at_str = read_str(I18n.t("insert.date")).chomp
            start_at = (start_at_str == ".") ? today : parse_day(start_at_str)
            value = MonetaryValue.from_float(read_float(I18n.t("insert.income_value")))  
            data.add_periodic_montary_changes PeriodicMonetaryChange.new(value, IntervalType.from_value(index), start_at, title)
        end
    end
    def self.add_periodic_expense(data)
        title = read_str(I18n.t("insert.title")).chomp
        title = "" if title == "_"
        if index = EXPENSE_INTERVALS_OPTS.ask.index
            start_at_str = read_str(I18n.t("insert.date")).chomp
            start_at = (start_at_str == ".") ? today : parse_day(start_at_str)
            value = MonetaryValue.from_float(read_float(I18n.t("insert.expense_value"))).negative
            data.add_periodic_montary_changes PeriodicMonetaryChange.new(value, IntervalType.from_value(index), start_at, title)
        end
    end
    def self.watch_prospections(data, app)
        show_info(data.formatted_prospections, I18n.t("title.prospections"), app)
    end
    def self.list_periodic_transactions(data, app)
        show_info(data.formatted_monetary_changes, I18n.t("title.transactions"), app)
    end

    # auxiliary method (not an action)
    def self.show_info(content, title, app)
        app.refresh_screen(title)
        puts content
        watch_options = OptionGroup.empty.with_cancel(I18n.t("option.go_back"))
        while option = watch_options.ask
            break if option.is_cancel?
            app.refresh_screen
            puts content
        end
    end
end
