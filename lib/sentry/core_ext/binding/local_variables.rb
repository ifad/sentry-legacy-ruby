if Gem::Version.new(RUBY_VERSION) < Gem::Version.new("2.2.0")
  class Binding
    def local_variables
      self.eval("local_variables")
    end
  end
end
