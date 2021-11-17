require "./node"

module CART
  class Leaf < Node
    def initialize(key, value)
      super()
      @node_type = NodeType::Leaf
    end


  end
end