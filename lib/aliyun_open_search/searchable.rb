require 'active_support/concern'

module AliyunOpenSearch
  module Searchable
    extend ActiveSupport::Concern
    
    module ClassMethods
      def update_opensearch
        params = {
          action: :push,
          table_name: self.app_table_name,
          items: []
        }
        self.unscoped.all.each do |t|
          params[:items] << if t.is_online then
            {
              cmd: 'update',
              fields: self.app_fields.inject(Hash.new){|h,f| h.merge({f => t.send(f)})}
            }
          else
            {cmd: 'delete', fields: {id: t.id}}
          end
        end
        puts "params size = #{params.to_json.size}"
        response = AliyunOpenSearch::Syncs.new(self.app_name).execute(params)
        response_body = JSON.load(response.body)
      end
      
      def opensearch(keyword, options={})
        #code
      end
    end
  end
end
