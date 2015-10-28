require "aliyun_open_search/version"
require "aliyun_open_search/base"
require "aliyun_open_search/syncs"
require "aliyun_open_search/search"
require "aliyun_open_search/scan"
require "aliyun_open_search/searchable"
require "aliyun_open_search/extend"

module AliyunOpenSearch
  ActiveRecord::Base.extend AliyunOpenSearch::Extend::Searchable
end
