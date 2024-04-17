require "./../classes/data.cr"
class LocaleLoader
    def self.load(locale : String)
        I18n.config.loaders << I18n::Loader::YAML.new("config/locales")
        I18n.config.default_locale = locale
        I18n.init
    end
end
