require "./../utils/console_read.cr"

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
        when Action::DELETE_TRANSACTION
            delete_transaction(data,app)
        end
        data.save
    end 
    def self.change_current_balance(data)
        new_balance = ConsoleReader.read_float(I18n.t("insert.new_balance"))
        data.current_balance = MonetaryValue.from_float(new_balance)
    end
    def self.add_periodic_income(data)
        self.add_transaction(data, true)
    end
    def self.add_periodic_expense(data)
        self.add_transaction(data, false)
    end
    def self.add_transaction(data, income? : Bool)
        title = ConsoleReader.read_str(I18n.t("insert.title")).chomp
        title = "" if title == "."
        index = (income? ? INCOME_INTERVALS_OPTS : EXPENSE_INTERVALS_OPTS).ask.get_index

        start_at_str = ConsoleReader.read_str(I18n.t("insert.date")).chomp
        start_at = nil
        until start_at
            begin
                start_at = (start_at_str == ".") ? today : parse_day(start_at_str)
                break
            rescue
                start_at_str = ConsoleReader.read_str(I18n.t("insert.date")).chomp
            end
        end
        value = MonetaryValue.from_float(ConsoleReader.read_float(I18n.t( income? ? "insert.income_value" : "insert.expense_value")))
        value = value.negative unless income? 
        data.add_periodic_monetary_changes PeriodicMonetaryChange.new(value, IntervalType.from_value(index), start_at.not_nil!, title)
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
    def self.watch_prospections(data, app)
        show_info(data.formatted_prospections, I18n.t("title.prospections"), app)
    end
    def self.list_periodic_transactions(data, app)
        app.refresh_screen(I18n.t("title.transactions"))
        puts data.formatted_monetary_changes
        options = self.build_transactions_page_options(data)
        while option = options.ask
            break if option.is_cancel?
            exec(option.action.not_nil!, app)
            app.refresh_screen(I18n.t("title.transactions"))
            puts data.formatted_monetary_changes
            options = self.build_transactions_page_options(data)
        end
    end
    def self.build_transactions_page_options(data)
        option_group = OptionGroup.empty.with_cancel(I18n.t("option.go_back"))
        option_group.options << Option.new(I18n.t("option.delete_transaction"), Action::DELETE_TRANSACTION) unless data.periodic_monetary_changes.empty?
        option_group
    end
    def self.delete_transaction(data,app)
        app.refresh_screen(I18n.t("title.transaction_deletion"))
        max_index = data.periodic_monetary_changes.size() - 1
        puts data.formatted_monetary_changes(true)
        index = -1
        while index < 0 || index > max_index
            index = ConsoleReader.read_int(I18n.t("insert.transaction_number")) - 1
        end
        
        app.refresh_screen(I18n.t("title.transaction_deletion"))
        pmc = data.periodic_monetary_changes[index]
        puts I18n.t("confirm.transaction_deletion", transaction: pmc.to_text, eol: EOL)
        answer = OptionGroup.new([Option.new(I18n.t("option.confirm"), 1)]).with_cancel(I18n.t("option.cancel")).ask
        if answer.get_index == 1
            data.periodic_monetary_changes.delete_at(index)
        end
    end
end
