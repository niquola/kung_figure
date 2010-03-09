require File.dirname(__FILE__) + '/test_helper.rb'


module MyModule
  include KungFigure
end

module MyModule
  class Config < KungFigure::Base
    define_prop :prop1,'default1'
    define_prop :prop2, 2
    class NestedConfig < KungFigure::Base
      define_prop :prop3,'prop3'
      class NestedNestedConfig < KungFigure::Base
        define_prop :prop4,'prop4'
      end
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
  end
end
