module CART
  class Tree
    property root : CART::Node | Nil = nil
    property size : UInt64 = 0

    def insert(key, value)
      recursive_insert(pointerof(@root), key, value)
    end

    def recursive_insert(node_ptr, key, value)
      # If we are inserting at a nil node, inject a leaf
      if node_ptr.value.nil?
        leaf = CART::Leaf.new(key, value)
        node_ptr.value = leaf
        return nil
      end

      # If we are inserting at a leaf, we need to replace it with a node
      if node_ptr.value.is_a?(CART::Leaf)
        # Type cast as leaf
        leaf = node_ptr.value.as(CART::Leaf)

        # If the keys are the same, we can replace the stored value
        if leaf.key == key
          old_val = leaf.value
          leaf.value = value
          return old_val
        end

        #  It's a new value, so we must split the leaf into a Node4
        new_node = CART::Node4.new()

        # Create a new leaf that holds the given key and value
        new_leaf = CART::Leaf.new(key, value)

        # Determine longest prefix between the original leaf and the new leaf
        # longest_prefix = longest_common_prefix(leaf, new_leaf, depth)
        longest_prefix = 0

        #  Store the longest prefix as the partial length on the Node4
        new_node.partial_length = longest_prefix

        # Add both leafs as children on the Node4
        # new_node.add_child(leaf)
        # new_node.add_child(new_leaf)

        # Set the given node to the new Node4
        node_ptr.value = new_node
      end

    end

    def delete(key); end

    def search(key); end

    def foreach(options); end

    def foreach_prefix(options); end

    def min; end

    def max; end
  end
end
