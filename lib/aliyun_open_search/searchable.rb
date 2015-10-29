require 'active_support/concern'

module AliyunOpenSearch
  module Searchable
    extend ActiveSupport::Concern
    
    module ClassMethods
      
      #同步数据到阿里云搜索
      #传入：无
      #返回：hash格式的结果：
      #       status      调用结果，OK仅代表接收数据成功，数据处理过程仍有可能出错
      #       request_id  任务请求id
      def update_opensearch
        params = {
          action: :push,
          table_name: self.aos_table_name,
          items: []
        }
        self.send(self.aos_add_scope).each do |t|
          params[:items] << { cmd: 'add',
                              fields: self.aos_fields.inject(Hash.new){|h,f| h.merge({f => t.send(f)})}
                            }
        end
        if self.aos_delete_scope
          self.send(self.aos_delete_scope).each do |t|
            params[:items] << {cmd: 'delete', fields: {id: t.id}}
          end
        end
        puts "params size = #{params.to_json.size}"
        response = AliyunOpenSearch::Syncs.new(self.aos_app_name).execute(params)
        response_body = JSON.load(response.body)
      end
      
      #执行全文搜索，固定只返回搜索结果的记录id，不返回其它字段
      #传入：keyword  以空格分隔的多个搜索关键字
      #     options  hash可选参数：
      #                per_page  每页记录数，缺省值=10
      #                page      返回第几页记录，从1起计，缺省值=1
      #                order     排序要求，如'-RANK;+created_at'
      #返回：hash格式的搜索结果：
      #       searchtime  搜索耗时，秒
      #       total       搜索得到的总记录数
      #       num         本次返回的记录数
      #       viewtotal   最大返回记录数
      #       items       返回的记录，每条记录含id和index_name两项
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
        response = JSON.load(AliyunOpenSearch::Search.new(self.aos_app_name).execute(params))
        puts response
        raise "Aliyun opensearch fail, return: #{response.to_s}" unless response['status'] == 'OK'
        response['result']
      end
    end
  end
end
