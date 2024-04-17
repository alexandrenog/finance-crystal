require "./*"
require "./classes/*"
require "./enums/*"
require "./utils/*"
require "i18n"

data = DataLoader.load_or_create

# Localized pre-instantiated Options Groups
INCOME_INTERVALS_OPTS = OptionGroup.new(
    [IntervalType::ONCE, IntervalType::MONTHLY, IntervalType::WEEKLY, IntervalType::FIVEDAYS_A_WEEK].map(&.to_option),
    I18n.t("insert.this_transaction_happens")
)

EXPENSE_INTERVALS_OPTS = OptionGroup.new(
    [IntervalType::ONCE, IntervalType::MONTHLY, IntervalType::WEEKLY, IntervalType::DAILY, IntervalType::FIVEDAYS_A_WEEK, IntervalType::TWODAYS_A_WEEK].map(&.to_option),
    I18n.t("insert.this_transaction_happens")
)

main_option_group = OptionGroup.new([
    Option.new(I18n.t("option.watch_prospections"), Action::WATCH_PROSPECTIONS),
    Option.new(I18n.t("option.list_transactions"), Action::LIST_PERIODIC_TRANSACTIONS),
    Option.new(I18n.t("option.register_transaction"), 
        OptionGroup.new([
            Option.new(I18n.t("option.register_income"), Action::ADD_PERIODIC_INCOME),
            Option.new(I18n.t("option.register_expense"), Action::ADD_PERIODIC_EXPENSE)
        ]).with_cancel(I18n.t("option.go_back"))
    ),
    Option.new(I18n.t("option.change_current_balance"), Action::CHANGE_CURRENT_BALANCE)
]).with_cancel(I18n.t("option.exit"))

App.new(main_option_group, data).run()
