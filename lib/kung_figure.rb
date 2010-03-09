module KungFigure

  def self.included(base)
    base.extend(ClassMethods)
  end

  def config
    self.class.config
  end

  module ClassMethods
    def set_root_config_class(klazz)
      @root_config_class = klazz
    end

    def root_config_class
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
    
    def get_from_enclosing_module(klazz_name)
      config_klazz_path=self.class.name.to_s.split('::')[0..-2]
      config_klazz_path<< klazz_name
      config_klazz_path.inject(Kernel){|parent,nxt|
         break unless parent.const_defined?(nxt) 
         parent.const_get(nxt.to_sym)
      }
    end

    def method_missing(key,&block)
      @props ||= {}
      klazz_name = camelize(key.to_s).to_sym
      child_cfg_clazz = self.class.const_get(klazz_name) if self.class.const_defined?(klazz_name)
      child_cfg_clazz ||= get_from_enclosing_module(klazz_name)

      raise "No such configuration #{key}" unless child_cfg_clazz

      unless @props.key?(key)
        @props[key] = if child_cfg_clazz.ancestors.include?(KungFigure::Base)
                        child_cfg_clazz.new
                      elsif child_cfg_clazz.respond_to?(:config)
                        child_cfg_clazz.config
                      end
      end
      @props[key].instance_eval(&block) if block_given?
      return @props[key]
    end
  end
end
