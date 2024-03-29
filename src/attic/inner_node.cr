require "./node"

module CART
  class InnerNode < Node
    # Properties common to all inner nodes
    property prefix : Array(Int32)
    property prefix_len : Int32
    property size : UInt8

    def initialize
      super

      @prefix = [] of Int32
      @prefix_len = 0
      @size = 0
    end

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

    def index_for(key : Char)
      -1
    end

    def index_for(key : Int32)
      -1
    end

    def replace_child(key : Char, node : Node)
      replace_child(key.ord, node)
    end

    def replace_child(key : Int32, node : Node)
      return false
    end

    # For convenience
    def prefix_mismatch(key : String, depth : Int)
      prefix_mismatch(key.codepoints, depth)
    end

    def to_s(io)
      io << "CART::#{@node_type} {\n"
      io << "  size: #{@size},\n"
      io << "  prefix: '#{@prefix.to_str}' (#{@prefix}),\n"
      io << "  prefix_len: #{@prefix_len}\n"
      io << "}\n"
    end
  end
end