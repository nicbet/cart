require "./inner_node"

module CART
  class Node16 < InnerNode
    # # Inner Node properties
    property keys : UInt8_16
    property children :  Node_16

    def initialize
      super
      @node_type = NodeType::Node16
      @keys = UInt8_16.new(0)
      @children = Node_16.new(Node.new)
    end

    def full?
      @size == max_size
    end

    def add_child(key : UInt8, node : Node)
      return false if full?

      # Determine the position to insert, instead of SIMD instructions, we use binary search
      index = @keys.bsearch_index { |k| key < k} || 0

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
      # Instead of SIMD instructions, we use binary search
      pos = @keys.bsearch_index { |k| key == k} || -1
      return pos
    end

    def find_child(key : UInt8)
      index = index_for(key)
      return children[index] if index > 0

      nil
    end
  end
end