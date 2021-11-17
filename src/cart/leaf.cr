require "./node"

module CART
  class Leaf < Node
    property key : String
    property value : String

    def initialize(key, value)
      @node_type = NodeType::Leaf
      @key = key
      @value = value
    end

    def min
      return self
    end

    def max
      return self
    end

    def matches_key?(key)
      @key == key
    end

    # Returns the longest number of bytes that match between the current node's prefix
    # and the given other node at the given depth
    def longest_common_prefix(other : Node, depth : Int)
      limit = Math.min(self.key.size, other.key.size) - depth
      i = 0
      while i < limit
        if key[depth+i] != other.key[depth+i]
          return i
        end
        i += 1
      end

      return i
    end
  end
end