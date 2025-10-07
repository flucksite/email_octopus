require "spec"
require "webmock"
require "../src/email_octopus"

def default_api_client(api_key : String = default_api_key)
  EmailOctopus::Client.new(api_key)
end

def default_api_key
  "eo_abd123test"
end

def test_url_for(path)
  File.join("https://api.emailoctopus.com", path)
end

def read_fixture(file : String)
  path = "#{__DIR__}/fixtures/#{file}"

  File.exists?(path) ||
    raise Exception.new("Fixture #{file} does not exist.")

  File.open(path)
end

Spec.after_each do
  WebMock.reset
end
