require "bundler/inline"

gemfile do
  source 'https://rubygems.org'
  gem "json"
  gem "sqlite3"
  gem "sinatra"
  gem "rackup"
  gem "puma"
  gem "activerecord"
  gem 'debug'
  gem "dotenv"
end

require 'dotenv/load'
require "active_record"

class AppSettings
  def self.signature_header = ENV.fetch("SIGNATURE_HEADER")
  def self.signing_secret = ENV.fetch("SIGNING_SECRET")
end

ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: "database.sqlite3")

ActiveRecord::Schema.define do
  create_table :payloads, id: false, if_not_exists: true do |t|
    t.json :body, null: false
    t.timestamps
  end
end

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end

class Payload < ApplicationRecord
end

require 'sinatra/base'

class MyApp < Sinatra::Base
  def verified_request?(request:)
    data = request.body.read
    request.body.rewind
    hmac = OpenSSL::HMAC.hexdigest('SHA256', AppSettings.signing_secret, data)
    given_hmac = request.env.fetch(AppSettings.signature_header)
    return Rack::Utils.secure_compare(given_hmac, hmac)
  end


  post '/' do
    return 403 unless verified_request?(request: request)
    parsed_body = JSON.parse(request.body.read)
    Payload.create!(
      body: parsed_body
    )

    return 204
  end

  run! if app_file == $0
end