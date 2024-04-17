require "./*"
require "i18n"

GO_BACK = "Go Back"

class App
    property data : Data
    def initialize(@main_option_group : OptionGroup)
        @data = read_or_create_data
        @info_row = InfoRow.new(@data)
    end

    def read_or_create_data
        begin
            return Data.from_yaml(File.read(Consts::DATA_FILE))
        rescue
            return Data.new(name: read_str(I18n.t("insert.username"))).save
        end
    end

    def run
        @main_option_group.inquiry(self)
    end
    
    def refresh_screen(title = "")
        print "\33c\e[3J"
        @info_row.title = title
        print @info_row
    end
    
end

I18n.config.loaders << I18n::Loader::YAML.new("config/locales")
I18n.config.default_locale = :pt
I18n.init

INCOME_INTERVALS_OPTS = OptionGroup.new([
    intervalTypeOption(IntervalType::ONCE),
    intervalTypeOption(IntervalType::MONTHLY),
    intervalTypeOption(IntervalType::WEEKLY),
    intervalTypeOption(IntervalType::FIVEDAYS_A_WEEK)
], I18n.t("insert.this_transaction_happens"))


EXPENSE_INTERVALS_OPTS = OptionGroup.new([
    intervalTypeOption(IntervalType::ONCE),
    intervalTypeOption(IntervalType::MONTHLY),
    intervalTypeOption(IntervalType::WEEKLY),
    intervalTypeOption(IntervalType::DAILY),
    intervalTypeOption(IntervalType::FIVEDAYS_A_WEEK),
    intervalTypeOption(IntervalType::TWODAYS_A_WEEK)
], I18n.t("insert.this_transaction_happens"))

App.new(
    OptionGroup.new([
        Option.new(I18n.t("option.watch_prospections"), Action::WATCH_PROSPECTIONS),
        Option.new(I18n.t("option.list_transactions"), Action::LIST_PERIODIC_TRANSACTIONS),
        Option.new(I18n.t("option.register_transaction"), 
            OptionGroup.new([
                Option.new(I18n.t("option.register_income"), Action::ADD_PERIODIC_INCOME),
                Option.new(I18n.t("option.register_expense"), Action::ADD_PERIODIC_EXPENSE)
            ]).with_cancel(GO_BACK)
        ),
        Option.new(I18n.t("option.change_current_balance"), Action::CHANGE_CURRENT_BALANCE)
    ]).with_cancel(I18n.t("option.exit"))
).run()
