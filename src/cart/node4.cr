require "./inner_node"

module CART
  class Node4 < InnerNode
    # Inner Node properties
    property keys : StaticArray(Int32, NODE_4_MAX)
    property children :  StaticArray(Node, NODE_4_MAX)

    def initialize
      super
      @node_type = NodeType::Node4
      @keys = StaticArray(Int32, NODE_4_MAX).new(0)
      @children = StaticArray(Node, NODE_4_MAX).new(Node.new)
    end

    def full?
      @size == max_size
    end

    # Covenience Method
    def add_child(key : Char, node : Node)
      add_child(key.ord, node)
    end

    def add_child(key : Int32, node : Node)
      return false if full?

      # Determine the position to insert
      index = @keys.index { |k| key < k} || @size

      # Insert element at index, shuffling others to the right if needed
      ((index+1)..@size).reverse_each do |i|
        @keys[i] = @keys[i-1]
        @children[i] = @children[i-1]
      end

      # Insert at index
      @keys[index] = key
      @children[index] = node
      @size += 1

      return true
    end

    # Covenience Method
    def index_for(key : Char)
      index_for(key.ord)
    end

    def index_for(key : Int32)
      pos = @keys.index { |k| key == k} || -1
      return pos
    end

    # Covenience Method
    def find_child(key : Char)
      find_child(key.ord)
    end

    def find_child(key : Int32)
      index = index_for(key)
      if index >= 0
        return children[index]
      else
        return nil
      end
    end

    # Returns the minimum child at the current node
    def min
      return @children[0].min
    end

    # Returns the max child at the current node
    def max
      return nil if @size == 0
      return @children[@size-1].max
    end

    # Copy metadata from other node
    def copy_meta(other : Node)
      @size = other.size
      @prefix = other.prefix
      @prefix_len = other.prefix_len
    end

    def to_s(io)
      io << "CART::#{@node_type} {\n"
      io << "  size: #{@size},\n"
      io << "  prefix: '#{@prefix.to_str}' (#{@prefix}),\n"
      io << "  prefix_len: #{@prefix_len},\n"
      io << "  keys: #{@keys},\n"
      io << "  children: #{@children.map(&.to_s)}\n"
      io << "}"
    end
  end
end