require "./node_type"

module CART
  class Node
    # Property common to all nodes
    property node_type : NodeType

    # Inner Node properties
    property keys : Array(UInt8)
    property children :  Array(Pointer(CART::Node))
    property prefix : Array(UInt8)
    property prefix_len : Int16
    property size : UInt8

    # Leaf Nodes
    property key : String | Nil
    property value : String | Nil
    property key_size : UInt64

    # Even though we are implementing an 'abstract' class
    # that we can never initialize, we need to provide a
    # dummy constructor to avoid a compiler error.
    # See https://github.com/crystal-lang/crystal/issues/2827
    def initialize
      @node_type = NodeType::None

      @keys = [] of UInt8
      @children = [] of Pointer(CART::Node)
      @prefix = [] of UInt8
      @prefix_len = 0
      @size = 0

      @key_size = 0
      @key = nil
      @value = nil
    end

    def to_s(io)
      io << "CART::#{@node_type}"
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
      @key == key
    end

    def value
      @value
    end

    def full?
      @keys.size == max_size
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

    def add_child(key : UInt8, node_ptr : Pointer(CART::Node))
      case @node_type
      when NodeType::Node4
        add_child_4(key, node_ptr)
      # when NodeType::Node16
      #   add_child_16(key, node)
      # when NodeType::Node48
      #   add_child_48(key, node)
      # when NodeType::Node256
      #   add_child_256(key, node)
      else
        return false
      end
    end


    def add_child_4(key : UInt8, node_ptr : Pointer(CART::Node))
      if full?
        grow!
        add_child(key, node_ptr)
      else
        # Determine the position to insert
        index = 0
        while index < @size
          break if key < @keys[index]
          index += 1
        end

        # Insert element at index, shuffling others if needed
        @keys.insert(index: index, object: key)

        # !! Compiler Bug !!
        @children.insert(index: index, object: node_ptr)
        @size += 1
      end
      return true
    end

    # def add_child_16(key, node_ptr); end
    # def add_child_48(key, node_ptr); end
    # def add_child_256(key, node_ptr); end

    def grow!
      # raise NotImplementedError
    end
  end
end
