RSpec::Matchers.define :be_i18n_keys do |expected|
  LOC_PREFIX = /^\w{2}\b/

  extract_keys = ->(actual){
    locales = I18n.available_locales.map(&:to_s)
    actual.split("\n").map { |x|
      x.strip!
      key = x.gsub(/\s+/, ' ').split(' ').reverse.detect { |p| p && p.include?('.') }
      if x =~ LOC_PREFIX && locales.include?(x[0..1]) && !(key =~ LOC_PREFIX && locales.include(key[0..1]))
        x.split(' ', 2)[0] + '.' + key
      else
        key
      end
    }
  }

  match do |actual|
    extract_keys.(actual).sort == expected.sort
  end

  failure_message_for_should do |actual|
    "Expected #{expected.sort}, but had #{extract_keys.(actual).sort}"

  end
end
