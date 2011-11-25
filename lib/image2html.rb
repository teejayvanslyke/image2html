$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'rubygems'
require 'bundler'

Bundler.setup

require 'cairo'
require 'tempfile'

require 'image2html/base'
require 'image2html/snapshot'



