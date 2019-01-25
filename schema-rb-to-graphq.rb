#!/usr/bin/env ruby

# frozen_string_literal: true

# Fake ApplicationRecord
class ApplicationRecord
  def method_missing(method_name, *args)
  end
end

require 'bundler/setup'
require 'active_support/inflector'
require 'active_record'
# Dir['./app/models/*'].each { |file| require file }

def convert(type)
  type
    .sub('string', 'String')
    .sub('int', 'Int')
    .sub('bigInt', 'Int')
    .sub('boolean', 'Boolean')
    .sub('datetime', 'string')
end

# Fake class, behave like `t.string`
class T
  def method_missing(method_name, *args)
    return nil if method_name == :index

    puts "  #{args[0]}: #{convert(method_name.to_s)}"
  end
end

# extending Object
class Object
  def enable_extension(*args); end

  def create_table(table_name, *_args)
    puts "type #{table_name.classify} {"
    yield T.new
    puts '}'
    puts ''
  end
end

# Fake ActiveRecord
module ActiveRecord
  # Fake ActiveRecord::Schema
  module Schema
    def self.define(_args, &block)
      puts block.call
    end
  end
end

require './db/schema.rb'
