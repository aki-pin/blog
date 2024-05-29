# frozen_string_literal: true

require 'rubygems'
require 'bundler/setup'

require 'cloudinary'
require 'cloudinary/search'
require 'cloudinary/uploader'
require 'cloudinary/utils'

require 'uri'

require_relative '../lib/ogp_uploader.rb'
require_relative '../lib/ogp_setter.rb'


if Cloudinary.config.api_key.blank?
  require_relative '../config/cld_config.rb'
end

raise '引数が不足しています．' unless ARGV.length == 1

path_arg= ARGV[0]

path_match = path_arg.match(/^path=(.+)$/)

raise '引数が不正です．' unless path_match

path = path_match[1]
cld_path = path.split('/')[2]
title_changed = false

updated_lines = File.readlines(path).map do |line|
  if line.match(/\!\[.*?\]\((.*?)\)/)
    image_relative_path = $1

    public_id = File.basename(image_relative_path, ".*")

    if public_id == "ogp"
      line
    else
      image_path = path.gsub('entry.md', image_relative_path.gsub('./', ''))
      url = ImageUploader.call(image_path, cld_path, public_id)
      line.gsub(image_relative_path, url)
    end
  else
    line
  end
end

File.open(path, 'w') { |file| file.puts(updated_lines) }
