if Gem::Version.new(RUBY_VERSION) < Gem::Version.new("2.3.0")
  require 'securerandom'

  class Thread
    def name
      @name ||= SecureRandom.uuid
    end

    def name=(value)
      @name = value
    end
  end
end
