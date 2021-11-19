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
    def search(key : Array(Int32))
      ensure_null_terminated(key)
      recursive_search(@root, key, 0)
    end

    def search(key : String)
      search(key.codepoints)
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
      recursive_search(current.find_child(key[depth]), key, depth)
    end

    # Convenience method to quickly insert a String, uses value as both key and value
    def insert(value : String)
      insert(value, value)
    end

    def insert(key : String, value : String)
      insert(key.codepoints, value.codepoints)
    end

    # Inserts the provided value that is indexed by
    # the provided key into the CART.
    def insert(key : Array(Int32), value : Array(Int32))
      ensure_null_terminated(key)
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
    def recursive_insert(current, ref, key : Array(Int32), value : Array(Int32), depth : Int)
      puts "[INSERT] <#{key}, #{value}> into #{current} at depth #{depth}"
      # Empty root -> create a leaf
      if current.null?
        node = Leaf.new(key, value)

        # Set new leaf node as current
        ref.value = node

        # Update size and return
        @size += 1
        return true
      end

      # Leaf node -> replace with a new inner node storing existing leaf and new leaf
      if current.leaf?
        # Treat current as an instance of Leaf to get access to the Leaf methods and properties
        current = current.as(Leaf)

        # Bail if key matches but should we overwrite value instead?
        return false if current.matches_key?(key)

        # Create new inner node
        node = Node4.new

        #  Create new leaf node
        new_leaf = Leaf.new(key, value)

        # Determine longest common prefix between current node and key
        limit = current.longest_common_prefix(new_leaf, depth)

        node.prefix_len = limit
        node.prefix = key[depth...Math.min(limit, MAX_PREFIX_LEN)]

        # Add both leafs to the new inner node
        node.add_child(current.key[depth+node.prefix_len], current)
        node.add_child(key[depth+node.prefix_len], new_leaf)

        # Set new inner node as current
        ref.value = node

        # Update size and return
        @size +=1
        return true
      end

      # Special case: key of the leaf to be inserted differs from the compressed path.
      # We need to create a new inner node is created above the current node and adjust
      # the compressed paths.
      current = current.as(InnerNode)
      if current.prefix_len != 0
        mismatch = current.prefix_mismatch(key, depth)

        # Key differs from compressed path
        if current.prefix_len != mismatch
          # Create a new inner node to contain the current node and the new key
          node = Node4.new

          # move mismatched prefix into the new inner node
          node.prefix_len = mismatch
          node.prefix = current.prefix[0...mismatch]

          # adjust prefixes so they fit underneath the new inner node
          if current.prefix_len < MAX_PREFIX_LEN
            new_k = current.prefix[mismatch]

            current.prefix_len -= (mismatch+1)
            current.prefix = current.prefix[(mismatch+1)..Math.min(current.prefix_len, MAX_PREFIX_LEN)]

            node.add_child(new_k, current)
          else
            min_key = current.min.not_nil!.key
            current.prefix_len -= (mismatch + 1)
            current.prefix = min_key[depth+mismatch+1..Math.min(current.prefix_len, MAX_PREFIX_LEN)]
            node.add_child(min_key[depth+mismatch], current)
          end

          new_leaf = Leaf.new(key, value)
          node.add_child(key[depth+mismatch], new_leaf)


          # Set new inner node as current
          ref.value = node

          # Update size and return
          @size +=1
          return true
        end

        depth += current.prefix_len
      end

      # Try to find the next child node to recursively call insert on
      next_node = current.find_child(key[depth])

      unless next_node.nil?
        # Recurse and keeping looking for an insertion point
        recursive_insert(next_node, pointerof(next_node), key, value, depth+1)
      else
        # Add new leaf at the current position
        current.add_child(key[depth], Leaf.new(key, value))
        @size += 1
        return true
      end
    end

    def delete(key); end

    def foreach(options); end

    def foreach_prefix(options); end

    def min; end

    def max; end

    def ensure_null_terminated(key : String)
      ensure_null_terminated(key.codepoints)
    end

    def ensure_null_terminated(key : Array(Int32))
      key << 0 if key.index(0).nil?
    end
  end
end
