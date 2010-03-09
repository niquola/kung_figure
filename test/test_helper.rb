def path(path)
  File.join(File.dirname(__FILE__),path)
end

$:.unshift(path('../lib'))
require "kung_figure"
require "test/unit"


