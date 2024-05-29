# frozen_string_literal: true

require 'rubygems'
require 'bundler/setup'

require 'cloudinary'
require 'cloudinary/search'
require 'cloudinary/uploader'
require 'cloudinary/utils'

require 'uri'

class OGPSetter
  def self.call(file_path, ogp_url)
    new.call(file_path, ogp_url)
  end

  def call(file_path, ogp_url)
    pattern = "---"
    ogp_text = "![ogp](#{ogp_url})"

    lines = File.readlines(file_path)

    index_to_insert = lines.rindex { |line| line.include?(pattern) }

    lines.insert(index_to_insert + 1, "#{ogp_text}\n")

    File.open(file_path, "w") { |file| file.puts(lines) }
  end
end
