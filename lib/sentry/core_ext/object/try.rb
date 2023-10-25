# try active support `try` first
begin
  require 'active_support/core_ext/object/try'
rescue LoadError
end

unless Object.method_defined?(:try)
  class Object
    def try(*a, &b)
      if a.empty? && block_given?
        yield self
      else
        __send__(*a, &b)
      end
    end
  end

  class NilClass
    def try(*args)
      nil
    end
  end
end
