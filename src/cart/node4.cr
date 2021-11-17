require "./inner_node"

module CART
  class Node4 < InnerNode
    # # Inner Node properties
    property keys : UInt8_4
    property children :  Node_4

    def initialize
      super
      @node_type = NodeType::Node4
      @keys = UInt8_4.new(0)
      @children = Node_4.new(Node.new)
    end

    def full?
      @size == max_size
    end

    def add_child(key : UInt8, node : Node)
      return false if full?

      # Determine the position to insert
      index = @keys.index { |k| key < k} || 0

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

    def index_for(key : UInt8)
      pos = @keys.index { |k| key == k} || -1
      return pos
    end

    def find_child(key : UInt8)
      index = index_for(key)
      return children[index] if index > 0

      nil
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
      io << "  prefix: '#{String.new(@prefix)}' (#{@prefix}),\n"
      io << "  prefix_len: #{@prefix_len},\n"
      io << "  keys: #{@keys},\n"
      io << "  children: #{@children}\n"
      io << "}\n"
    end
  end
end