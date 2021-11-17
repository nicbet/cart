module CART
  class Tree
    property root : Node
    property size : UInt64

    def initialize
      @root = Node.new
      @size = 0
    end

    # Return the node that contains the provided key,
    # or nil if not found
    def search(key : String)
      recursive_search(@root, key, 0)
    end

    # Recursive search helper function that traverses the tree.
    # Returns the value of the node that contains the passed in key, or nil if not found.
    def recursive_search(current, key, depth)
      return nil if current.nil? || current.null?

      # If we are looking at a leaf node try to match the given key
      if current.leaf?
        if current.matches_key?(key)
          return current.value
        end
        return nil
      end

      # Check if our key mismatches the current compressed path
      if current.prefix_mismatch(key, depth) != current.prefix_len
        # Bail if there is a mismatch during traversal
        return nil
      else
        # Otherwise increase depth accordingly
        depth += current.prefix_len
      end

      # Find the next node at specified index and depth
      recursive_search(current.find_child(key[depth].to_u8), key, depth+1)
    end

    # Inserts the provided value that is indexed by
    # the provided key into the CART.
    def insert(key, value)
      recursive_insert(@root, pointerof(@root), key, value, 0)
    end

    #   Recursive helper function that traverses the tree until an insertion point is found.
    # There are four methods of insertion:
    #
    # 1. If the current node is a NodeType::None, a Leaf new node is created with the passed in key-value pair
    # and inserted at the current position.
    #
    # 2. If the current node is a Leaf node, it will expand to a new ArtNode of type NODE4
    # to contain itself and a new leaf node containing the passed in key-value pair.
    #
    # 3. If the current node's prefix differs from the key at a specified depth,
    # a new ArtNode of type NODE4 is created to contain the current node and the new leaf node
    # with an adjusted prefix to account for the mismatch.
    #
    # 4. If there is no child at the specified key at the current depth of traversal, a new leaf node
    # is created and inserted at this position.
    def recursive_insert(current, ref, key : String, value : String, depth : Int)
      # Empty root -> create a leaf
      if current.null?
        node = Leaf.new(key, value)
        ref.value = node
        @size += 1
        return true
      end

      # Leaf node -> replace with a new inner node storing existing leaf and new leaf
      if current.leaf?
        # Create new inner node
        node = Node4.new

        #  Create new leaf node
        new_leaf = Leaf.new(key, value)

        # Determine longest common prefix between current node and key
        limit = current.longest_common_prefix(new_leaf, depth)

        node.prefix_len = limit
        node.prefix = key[depth..Math.min(limit, MAX_PREFIX_LEN)-1].to_slice

        # Add both leafs to the new inner node
        node.add_child(current.as(Leaf).key.bytes[depth+node.prefix_len], current)
        node.add_child(key.bytes[depth+node.prefix_len], new_leaf)

        # Set new inner node as current
        ref.value = node
      end

    end

    def delete(key); end

    def foreach(options); end

    def foreach_prefix(options); end

    def min; end

    def max; end
  end
end
