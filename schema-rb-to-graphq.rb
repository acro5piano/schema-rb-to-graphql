#!/usr/bin/env ruby

require 'bundler/setup'
require 'active_support/inflector'

def convert(type)
  type
    .sub('string', 'String')
    .sub('int', 'Int')
    .sub('bigInt', 'Int')
    .sub('boolean', 'Boolean')
    .sub('datetime', 'string')
end

class T
  def method_missing(method_name, *args, &block)
    return nil if method_name == :index

    puts "  #{args[0]}: #{convert(method_name.to_s)}"
  end
end

class Object
  def enable_extension(*args)
  end

  def create_table(table_name, *args, &block)
    puts "type #{table_name.classify} {"
    block.call(T.new)
    puts "}"
    puts ""
  end
end

module ActiveRecord
  module Schema
    def self.define(args, &block)
      puts block.call
    end
  end
end

require './db/schema.rb'
