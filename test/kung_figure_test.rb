require File.dirname(__FILE__) + '/test_helper.rb'

module MyModule
  include KungFigure
  class Config < KungFigure::Base
    define_prop :prop1,'default1'
    define_prop :prop2, 2
    define_prop :bool,true

    class NestedConfig < KungFigure::Base
      define_prop :prop3,'prop3'

      class NestedNestedConfig < KungFigure::Base
        define_prop :prop4,'prop4'
      end
    end
  end
end

module Another
  include KungFigure
  class Config < KungFigure::Base
    define_prop :prop,'default'
  end
end


module MyModule
  class WorkHorse
    include KungFigure
    class Config < KungFigure::Base
      define_prop :my_config,'default'
    end
  end
end

class TestKungFigure < Test::Unit::TestCase
  def test_configuration
    assert_equal('default1',MyModule.config.prop1)
    assert_equal(2,MyModule.config.prop2)
    assert_equal('prop3',MyModule.config.nested_config.prop3)
    assert_equal('prop4',MyModule.config.nested_config.nested_nested_config.prop4)

    MyModule.config.nested_config.nested_nested_config.prop4 'new value'
    assert_equal('new value',MyModule.config.nested_config.nested_nested_config.prop4)

    MyModule.configure do
      nested_config do
        prop3 'value3'
      end
    end

    assert_equal('value3',MyModule.config.nested_config.prop3)
  end

  def test_bug_with_boolean
    MyModule.configure do
      bool false
    end
    assert_equal(false,MyModule.config.bool)
  end

  def test_nested_config_declaration
    MyModule.clear_config!
    assert_equal('default',MyModule.config.work_horse.my_config)
    assert_equal('default',MyModule::WorkHorse.config.my_config)
    MyModule.configure do
      work_horse do
        my_config 'new value'
      end
    end
    assert_equal('new value',MyModule.config.work_horse.my_config)
    assert_equal('new value',MyModule::WorkHorse.config.my_config)
    assert_equal(MyModule::WorkHorse.config,MyModule::WorkHorse.new.config)
  end

  def test_clear_configuration
    MyModule.config.work_horse.my_config 'some config'
    MyModule.config.prop1 'some config'
    Another.config.prop 'some config'
    MyModule.clear_config!
    assert_equal('default',MyModule.config.work_horse.my_config)
    assert_equal('default1',MyModule.config.prop1)
    assert_equal('some config',Another.config.prop,'This branch not cleared')
  end
end
