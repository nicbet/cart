require "./node"

module CART
  class Leaf < CART::Node
    property key : String
    property value : String

    def initialize(key, value)
      @key = key
      @value = value
    end

    def to_s(io)
      io << "CART::Leaf #{@key} -> #{@value}>"
    end
  end
end
