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

raise '引数が不足しています．' unless ARGV.length == 3

title_arg, path_arg, author_arg = ARGV

title_match = title_arg.match(/^title=(.+)$/)
path_match = path_arg.match(/^path=(.+)$/)
author_match = author_arg.match(/^author=(.+)$/)

raise '引数が不正です．' unless title_match && path_match && author_match

title = title_match[1]
path = path_match[1]
author = author_match[1]

ogp_url = OGPUploader.call(title, path, author)

OGPSetter.call("tmp_draft.md", ogp_url)
