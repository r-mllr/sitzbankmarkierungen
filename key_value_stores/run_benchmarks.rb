#!/usr/bin/env ruby
# frozen_string_literal: true

require 'bundler/inline'

gemfile do
  source 'https://rubygems.org'

  gem 'benchmark-ips'
  gem 'ostruct'
end

Dir.glob("#{File.dirname(File.absolute_path(__FILE__))}/lib/*").sort.each(&method(:require))
require_relative '../lib/g_c_suite'

suite = GCSuite.new

puts '========== INITIALIZATION =========='

Benchmark.ips do |x|
  x.config(time: 5, warmup: 5, suite: suite)

  x.report('OpenStruct') do
    ContextOpenStruct.new(result: { first_name: 'Udo', last_name: 'Udonson' })
  end

  x.report('Class') do
    ContextClass.new(result: { first_name: 'Udo', last_name: 'Udonson' })
  end

  x.report('Struct') do
    ContextStruct.new(result: { first_name: 'Udo', last_name: 'Udonson' })
  end

  x.report('Hash') do
    { result: { first_name: 'Udo', last_name: 'Udonson' } }
  end

  x.compare!
end

puts '=============== READ ==============='

cos = ContextOpenStruct.new(result: { first_name: 'Udo', last_name: 'Udonson' })
cc = ContextClass.new(result: { first_name: 'Udo', last_name: 'Udonson' })
cs = ContextStruct.new(result: { first_name: 'Udo', last_name: 'Udonson' })
ch = { result: { first_name: 'Udo', last_name: 'Udonson' } }

Benchmark.ips do |x|
  x.config(time: 5, warmup: 5, suite: suite)

  x.report('OpenStruct') do
    cos.result
  end

  x.report('Class') do
    cc.result
  end

  x.report('Struct') do
    cs.result
  end

  x.report('Hash.fetch') do
    ch.fetch(:result, {})
  end

  x.report('Hash[:key]') do
    ch[:result]
  end

  # rubocop: disable Style/SingleArgumentDig
  x.report('Hash.dig') do
    ch.dig(:result)
  end
  # rubocop: enable Style/SingleArgumentDig

  x.compare!
end

puts '============== WRITE ==============='

Benchmark.ips do |x|
  x.config(time: 5, warmup: 5, suite: suite)

  x.report('OpenStruct') do
    cos.errors = [{ base: 'this is a base error' }]
  end

  x.report('Class') do
    cc.errors = [{ base: 'this is a base error' }]
  end

  x.report('Struct') do
    cs.errors = [{ base: 'this is a base error' }]
  end

  x.report('Hash') do
    ch[:errors] = [{ base: 'this is a base error' }]
  end

  x.compare!
end
