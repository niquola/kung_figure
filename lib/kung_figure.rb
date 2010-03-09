module KungFigure
  ROOT_CONFIG_CLASS = :Config
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def set_root_config_class(klazz)
      @root_config_class = klazz
    end

    def root_config_class
      @root_config_class || :Config
      self.const_get(@root_config_class || :Config)
    end

    def config
      @config ||= root_config_class.new
    end

    def configure(&block)
      config.instance_eval &block
    end

    def load_config(path)
      load path
    end
  end

  class Base
    class << self
      def define_prop(name,default)
        define_method(name) do |*args|
          @props ||= {}
          if args.length > 0
            @props[name] = args[0]
          else
            @props[name] || default
          end
        end
      end
    end

    def camelize(str)
      str.split('_').map{|l| l.capitalize}.join('')
    end

    def method_missing(key,&block)
      @props ||= {}
      child_cfg_clazz = self.class.const_get(camelize(key.to_s).to_sym)
      raise "No such configuration #{key}" unless child_cfg_clazz

      unless @props.key?(key)
        @props[key] = child_cfg_clazz.new
      end
      @props[key].instance_eval(&block) if block_given?

      return @props[key]
    end
  end
end
