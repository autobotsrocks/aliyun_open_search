module AliyunOpenSearch
  module Extend
    module Searchable
      def acts_as_searchable(fields, app_name, table_name=nil)
        require 'aliyun_open_search/searchable'
        include AliyunOpenSearch::Searchable
        
        class_eval do
          class_attribute :app_name, :app_table_name, :app_fields
          self.app_name = app_name
          self.app_table_name = table_name || self.table_name.to_sym
          self.app_fields = fields
        end
      end
    end
  end
end
