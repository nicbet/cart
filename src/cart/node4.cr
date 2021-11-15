module CART
  class Node4 < CART::Node
    property keys : Array
    property value : Array

    def add_child(node)
      # If we have room
      if num_children < 4

      else # we need to split the node into a node16
        raise "not implemented"
      end
    end
  end
end
