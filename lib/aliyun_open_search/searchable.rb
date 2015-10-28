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
        per_page = (options[:per_page] || 10).to_i
        start = ((options[:page] || 1).to_i - 1) * per_page
        query = 'query=' + keyword.split().map{|k| "default:'#{k}'"}.join(' OR ')
        config = "config=start:#{start},hit:#{per_page}"
        sort = options[:order].nil? ? nil : "sort=#{options[:order]}"
        params = {
          query: [query, config, sort],
          fetch_fields: :id,
        }
        response = JSON.load(AliyunOpenSearch::Search.new(self.app_name).execute(params))
        puts response
        raise "Aliyun opensearch fail, return: #{response.to_s}" unless response['status'] == 'OK'
        response['result']
      end
    end
  end
end
