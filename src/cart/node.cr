require "./node_type"

module CART
  class Node
    # Property common to all nodes
    property node_type : NodeType

    # Even though we are implementing an 'abstract' class
    # that we can never initialize, we need to provide a
    # dummy constructor to avoid a compiler error.
    # See https://github.com/crystal-lang/crystal/issues/2827
    def initialize
      @node_type = NodeType::None
    end

    def to_s(io)
      io << "CART::#{@node_type}"
    end

    def null?
      @node_type.none?
    end

    def children
      raise("Not implemented")
    end

    def leaf?
      @node_type.leaf?
    end

    def inner_node?
      @node_type.inner_node?
    end

    def node4?
      @node_type.node4?
    end

    def node16?
      @node_type.node16?
    end

    def node48?
      @node_type.node48?
    end

    def node256?
      @node_type.node256?
    end

    def matches_key?(key)
      false
    end

    def prefix_mismatch(key : String, depth : Int)
      prefix_mismatch(key.codepoints, depth)
    end

    def prefix_mismatch(key : Array(Int32), depth : Int)
      return 0
    end

    def prefix
      Bytes.new(0)
    end

    def prefix_len
      0
    end

    def full?
      true
    end

    def index(key : UInt8)
      -1
    end

    def min
      nil
    end

    def max
      nil
    end

    def find_child(key : Char)
      find_child(key.ord)
    end

    def find_child(key : Int32)
      raise("Not implemented")
    end

    def value
      raise("Not implemented")
    end

    def longest_common_prefix(other : Node, depth : Int)
      return 0
    end

    def max_size
      case @node_type
      when NodeType::Node4
        CART::NODE_4_MAX
      when NodeType::Node16
        CART::NODE_16_MAX
      when NodeType::Node48
        CART::NODE_48_MAX
      when NodeType::Node256
        CART::NODE_256_MAX
      else
        0
      end
    end

    def min_size
      case @node_type
      when NodeType::Node4
        CART::NODE_4_MIN
      when NodeType::Node16
        CART::NODE_16_MIN
      when NodeType::Node48
        CART::NODE_48_MIN
      when NodeType::Node256
        CART::NODE_256_MIN
      else
        0
      end
    end

    def add_child(key : Int32, node : Node)
      raise("Not implemented")
    end

    def add_child(key : Char, node : Node)
      raise("Not implemented")
    end
  end
end
