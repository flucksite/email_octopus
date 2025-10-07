require "spec"
require "webmock"
require "../src/email_octopus"

def configure_api_key(api_key : String = default_api_key) : Void
  EmailOctopus::Client.configure do |settings|
    settings.api_key = api_key
  end
end

def default_api_key
  "eo_abd123test"
end

def read_fixture(file : String) : IO
  path = "#{__DIR__}/fixtures/#{file}"

  File.exists?(path) ||
    raise Exception.new("Fixture #{file} does not exist.")

  File.open(path)
end

Spec.after_each do
  WebMock.reset
end
