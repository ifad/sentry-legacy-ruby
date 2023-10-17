require 'zlib'

unless Zlib.method_defined?(:gzip)
  require 'securerandom'

  module Zlib
    def gzip(data)
      tmppath = File.join(Dir.tmpdir, SecureRandom.uuid)
      Zlib::GzipWriter.open(tmppath) do |gz|
        gz.write(data)
      end
      result = File.read(tmppath)
      File.unlink(tmppath)
      result
    end

    module_function :gzip
  end
end
