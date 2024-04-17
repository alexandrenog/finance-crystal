class DataLoader
    def self.load_or_create
        begin
            data = Data.from_yaml(File.read(Consts::DATA_FILE))
            LocaleLoader.load(data.locale)
            return data
        rescue
            language_options = OptionGroup.new([Option.new("English", 0), Option.new("Português", 1)],"Language/Idioma").no_locale
            locale =  ["en","pt"][language_options.ask.get_index]
            LocaleLoader.load(locale)
            return Data.new(locale: locale, name: ConsoleReader.read_str(I18n.t("insert.username"))).save
        end
    end
end