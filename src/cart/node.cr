module CART
  class Node
    property num_children : Int8 = 0
    property partial_length : Int32 = 0

    def to_s(io)
      io << "CART::Node"
    end
  end
end
