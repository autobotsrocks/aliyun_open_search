require 'active_support/concern'

module AliyunOpenSearch
  module Searchable
    extend ActiveSupport::Concern
    
    module ClassMethods
      def update_opensearch
        
      end
      
      def opensearch(keyword, options={})
        #code
      end
    end
  end
end
