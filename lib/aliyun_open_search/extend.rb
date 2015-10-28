module AliyunOpenSearch
  module Extend
    module Searchable
      def acts_as_searchable(*fields)
        require 'aliyun_open_search/searchable'
        include AliyunOpenSearch::Searchable
        
        class_eval do
          class_attribute :app_name, :app_table_name, :app_fields
          self.app_name = 'rds_sjll_teacher'
          self.app_table_name = :teachers
          self.app_fields = fields
        end
      end
    end
  end
end
