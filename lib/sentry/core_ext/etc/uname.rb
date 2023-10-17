if Gem::Version.new(RUBY_VERSION) < Gem::Version.new("2.2.0")
  module Etc
    def uname
      @uname ||= {
        sysname: `uname -s`.strip,
        nodename: `uname -n`.strip,
        release: `uname -r`.strip,
        version: `uname -v`.strip,
        machine: `uname -m`.strip
      }
    end
    module_function :uname
  end
end
