module AliyunOpenSearch
  module Extend
    module Searchable
      def setup_opensearch(app_name, fields, options={})
        require 'aliyun_open_search/searchable'
        include AliyunOpenSearch::Searchable
        
        class_eval do
          class_attribute :aos_app_name, :aos_table_name, :aos_fields, :aos_add_scope, :aos_delete_scope
          self.aos_app_name = app_name
          self.aos_fields = fields
          self.aos_table_name = options[:table_name] || self.table_name.to_sym
          self.aos_add_scope = options[:add_scope] || :all
          self.aos_delete_scope = options[:delete_scope]
        end
      end
    end
  end
end
