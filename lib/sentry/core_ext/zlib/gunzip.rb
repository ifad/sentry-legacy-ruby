require 'zlib'

unless Zlib.method_defined?(:gunzip)
  require 'tempfile'

  module Zlib
    def gunzip(data)
      result = nil
      Tempfile.create('zlib-gunzip') do |f|
        f.write(data)
        f.rewind

        gz = Zlib::GzipReader.new(f)
        result = gz.read.dup
        gz.close
      end
      result
    end

    module_function :gunzip
  end
end
