module AliyunOpenSearch
  module Extend
    module Searchable
      
      #在model中设置阿里云搜索的相关配置
      #传入：app_name  阿里云搜索的应用名
      #     fields    与此model对应的阿里云搜索主表字段，用数组表示，每个数组元素对应一个字段，model中应实现同名的实例方法返回字段值
      #     options   hash可选参数：
      #                 table_name    给定主表名，缺省取model表名；
      #                 add_scope     给定同步数据时需加入的记录scope；
      #                 delete_scope  给定同步数据时需删除的记录scope；
      #例子：
      #class Car < ActiveRecord::Base
      #  scope :online, -> { where(is_online: true) }
      #  scope :offline, -> { where(is_online: false) }
      #      
      #  setup_opensearch  ENV.fetch("APP_NAME"), %w(id styl_name acquirer_id), 
      #                    add_scope: :online, delete_scope: :offline
      #end
      #...
      #Car.update_opensearch  #同步数据到阿里云搜索
      #Car.opensearch('搜索', order: '-RANK;+acquirer_id')
      def setup_opensearch(app_name, fields, options={})
        require 'aliyun_open_search/searchable'
        include AliyunOpenSearch::Searchable
        
        class_eval do
          raise 'Fields of aliyun_opensearch not specified' unless fields.is_a?(Array) and fields.size > 0
          class_attribute :aos_app_name, :aos_table_name, :aos_fields, :aos_add_scope, :aos_delete_scope
          self.aos_app_name = app_name.to_s
          self.aos_fields = fields
          self.aos_table_name = options[:table_name] || self.table_name.to_sym
          self.aos_add_scope = options[:add_scope] || :all
          self.aos_delete_scope = options[:delete_scope]
        end
      end
    end
  end
end
