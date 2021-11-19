require "./node"

module CART
  class Leaf < Node
    property key : Array(Int32)
    property value : Array(Int32)

    def initialize(key : Array(Int32), value : Array(Int32))
      @node_type = NodeType::Leaf
      @key = key
      @value = value
    end

    def initialize(key : String, value : String)
      @node_type = NodeType::Leaf
      @key = key.codepoints
      @value = value.codepoints
    end

    def min
      return self
    end

    def max
      return self
    end

    def matches_key?(key : Array(Int32))
      @key == key
    end

    # For convenience
    def matches_key?(key : String)
      matches_key?(key.codepoints)
    end

    def value
      @value.to_str
    end

    def key_str
      @key.to_str.delete("\u0000")
    end

    # Returns the longest number of bytes that match between the current node's prefix
    # and the given other node at the given depth
    def longest_common_prefix(other : Node, depth : Int)
      limit = Math.min(self.key.size, other.key.size) - depth
      i = 0
      while i < limit
        if self.key[depth+i] != other.key[depth+i]
          return i
        end
        i += 1
      end

      return i
    end

    def to_s(io)
      io << "CART::#{@node_type}{key: '#{key_str}', value: '#{value}'}"
    end
  end
end