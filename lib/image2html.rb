$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'rubygems'
require 'bundler'

Bundler.setup

require 'cairo'
require 'tempfile'

require 'image2html/base'
require 'image2html/snapshot'
require 'image2html/video'

module Image2Html

  class << self

    def root
      Pathname.new(File.dirname(__FILE__) + '/../')
    end

    def tmp_path
      root.join('tmp')
    end

    def output_path
      root.join('output')
    end

  end

end

