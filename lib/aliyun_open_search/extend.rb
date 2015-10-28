module AliyunOpenSearch
  module Extend
    module Searchable
      def acts_as_searchable(*fields)
        require 'aliyun_open_search/searchable'
        include AliyunOpenSearch::Searchable
      end
    end
  end
end
