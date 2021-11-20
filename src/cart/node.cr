module CART
  class Node
    # Common to all Node types
    property node_type : NodeType

    # Common to all inner nodes
    property prefix : Array(Int32)
    property prefix_len : Int32
    property size : UInt8
    property keys : Array(Int32)
    property children :  Array(Pointer(Node))

    # Leaf Nodes
    property key : Array(Int32)
    property value : Array(Int32)

    def initialize(node_type : NodeType)
      @node_type = node_type

      @prefix = [] of Int32
      @prefix_len = 0
      @size = 0
      @keys = [] of Int32
      @children = [] of Pointer(Node)

      @key = [] of Int32
      @value = [] of Int32
    end

    # Helpers for checking the Node type
    def null?
      @node_type.none?
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

    # Max size constraints for different types of Node
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

    # Min size constraints for different types of Node
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

    # Determine if this Node is full
    def full?
      @size == max_size
    end

    # Returns the number of codepoints that differ between the passed in key
    # and the compressed path of the current node at the specified depth.
    def prefix_mismatch(key : Array(Int32), depth : Int)
      index = 0

      if @prefix_len > MAX_PREFIX_LEN
        while index < MAX_PREFIX_LEN
          return index if key[depth+index] != @prefix[index]
          index += 1
        end

        min_key = min.try &.key
        return index if min_key.nil?

        while index < @prefix_len
          return index if key[depth+index] != min_key[index]
          index += 1
        end
      else
        while index < @prefix_len
          return index if key[depth+index] != @prefix[index]
          index += 1
        end
      end

      return index
    end

    # For convenience, overload to all calling directly with a String value
    def prefix_mismatch(key : String, depth : Int)
      prefix_mismatch(key.codepoints, depth)
    end

    # Add a child to an inner node if not full
    def add_child(key : Int32, node_ptr : Pointer(Node))
      return false if full?
      return false unless inner_node?

      # Determine the position to insert
      index = @keys.index { |k| key < k} || @size

      # Insert element at index, shuffling others to the right if needed
      ((index+1)..@size).reverse_each do |i|
        @keys[i] = @keys[i-1]
        @children[i] = @children[i-1]
      end

      # Insert at index
      @keys[index] = key
      @children[index] = node_ptr
      @size += 1

      return true
    end

    # For convenience, overload to all calling directly with a Char value
    def add_child(key : Char, node_ptr : Pointer(Node))
      add_child(key.ord, node_ptr)
    end

    # Add a child to an inner node if not full
    def replace_child(key : Int32, node_ptr : Pointer(Node))
      return false unless inner_node?

      index = index_for(key)
      if index >= 0
        @keys[index] = key
        @children[index] = node_ptr
      end
      return true
    end

    def replace_child(key : Char, node_ptr : Pointer(Node))
      replace_child(key.ord, node_ptr)
    end

    # Find the key index for a given key, or -1 if key does not exist
    def index_for(key : Int32)
      pos = @keys.index { |k| key == k} || -1
      return pos
    end

    # For convenience, overload to all calling directly with a Char value
    def index_for(key : Char)
      index_for(key.ord)
    end

    # Returns a pointer to the child that matches the passed in key or nil if not present
    def find_child(key : Int32)
      index = index_for(key)
      if index >= 0
        return children[index]
      else
        return nil
      end
    end

    # For convenience, overload to all calling directly with a Char value
    def find_child(key : Char)
      find_child(key.ord)
    end

    # Returns the minimum child at the current node
    def min
      return self if leaf?
      return nil if null? || @size == 0
      return @children[0].value.min
    end

    # Returns the max child at the current node
    def max
      return self if leaf?
      return nil if null? || @size == 0
      return @children[@size-1].value.max
    end

    # Copy metadata from other Node
    def copy_meta(other : Node)
      @size = other.size
      @prefix = other.prefix
      @prefix_len = other.prefix_len
    end

    # For Leaf nodes: determine whether leaf matches given key
    def matches_key?(key : Array(Int32))
      @key == key
    end

    # For convenience, overload to all calling directly with a String value
    def matches_key?(key : String)
      matches_key?(key.codepoints)
    end

    # Return the value stored in this node
    def value
      @value.to_str
    end

    # Return the key stored in this node as a String
    # with null-termination removed if the key has such
    def key_str
      @key.to_str.delete("\u0000")
    end

    # Returns the longest number of bytes that match between the leaf node's prefix
    # and the given other leaf node at the given depth
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

    # Serialization to output
    def to_s(io)
      if null?
        io << "CART::#{@node_type}"
      else
        io << "CART::#{@node_type}{"
        io << "keys=#{@keys} "
        io << "children=#{@children.map(&.address)} "
        io << "prefix=#{@prefix} "
        io << "prefix_len=#{@prefix_len} "
        io << "size=#{@size} "
        io << "key=#{@key} "
        io << "key_size=#{@key.size} "
        io << "value=#{@value}"
        io << "}"
      end
    end


  end
end