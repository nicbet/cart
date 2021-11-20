module CART
  class Tree
    property root : Pointer(Node)
    property size : UInt64

    def initialize
      @root = Pointer(Node).null
      @size = 0
    end

    # Inserts the provided value that is indexed by
    # the provided key into the Tree.
    def insert(key : Array(Int32), value : Array(Int32))
      ensure_null_terminated(key)
      recursive_insert(@root, pointerof(@root), key, value, 0)
    end

    # Recursive helper function that traverses the tree until an insertion point is found.
    # There are four methods of insertion:
    #
    # 1. If the current node is a NodeType::None, a Leaf new node is created with the passed in key-value pair
    # and inserted at the current position.
    #
    # 2. If the current node is a Leaf node, it will expand to a new Node of type NODE4
    # to contain itself and a new leaf node containing the passed in key-value pair.
    #
    # 3. If the current node's prefix differs from the key at a specified depth,
    # a new Node of type NODE4 is created to contain the current node and the new leaf node
    # with an adjusted prefix to account for the mismatch.
    #
    # 4. If there is no child at the specified key at the current depth of traversal, a new leaf node
    # is created and inserted at this position.
    def recursive_insert(current_ptr, ref, key : Array(Int32), value : Array(Int32), depth : Int)
      # Empty root -> create a leaf
      if current_ptr.null?
        # Set new leaf node as current
        ref.value = CART.make_leaf_ptr(key, value)

        # Update size and return
        @size += 1
        return true
      end

      # To make our code less verbose
      current = current_ptr.value

      # Leaf node -> replace with a new inner node storing existing leaf and new leaf
      if current.leaf?
        # Bail if key matches but should we overwrite value instead?
        return false if current.matches_key?(key)

        # Create new inner node
        node_ptr = CART.make_node4_ptr

        #  Create new leaf node
        leaf_ptr = CART.make_leaf_ptr(key, value)
        leaf = leaf_ptr.value

        # Determine longest common prefix between current node and key
        limit = current.longest_common_prefix(leaf, depth)

        node_ptr.value.prefix_len = limit
        node_ptr.value.prefix = key[depth...Math.min(limit, MAX_PREFIX_LEN)]

        # Add both leafs to the new inner node
        node_ptr.value.add_child(current.key[depth+limit], current_ptr)
        node_ptr.value.add_child(key[depth+limit], leaf_ptr)

        # Set new inner node as current
        ref.value = node_ptr

        # Update size and return
        @size +=1
        return true
      end

      # Special case: key of the leaf to be inserted differs from the compressed path.
      # We need to create a new inner node is created above the current node and adjust
      # the compressed paths.
      if current.prefix_len != 0
        mismatch = current.prefix_mismatch(key, depth)

        # Key differs from compressed path
        if current.prefix_len != mismatch
          # Create a new inner node to contain the current node and the new key
          node_ptr = CART.make_node4_ptr
          node = node_ptr.value


          # move mismatched prefix into the new inner node
          node.prefix_len = mismatch
          node.prefix = current.prefix[0...mismatch]

          # adjust prefixes so they fit underneath the new inner node
          if current.prefix_len < MAX_PREFIX_LEN
            new_k = current.prefix[mismatch]

            current.prefix_len -= (mismatch+1)
            current.prefix = current.prefix[(mismatch+1)..Math.min(current.prefix_len, MAX_PREFIX_LEN)]

            node.add_child(new_k, current_ptr)
          else
            min_key = current.min.not_nil!.key
            current.prefix_len -= (mismatch + 1)
            current.prefix = min_key[depth+mismatch+1..Math.min(current.prefix_len, MAX_PREFIX_LEN)]
            node.add_child(min_key[depth+mismatch], current_ptr)
          end

          leaf = CART.make_leaf_ptr(key, value)
          node.add_child(key[depth+mismatch], leaf)


          # Set new inner node as current
          ref.value = node_ptr

          # Update size and return
          @size +=1
          return true
        end

        depth += current.prefix_len
      end

      # Try to find the next child node to recursively call insert on
      next_node = current.find_child(key[depth])

      unless next_node.nil? || next_node.null?
        # Recurse and keeping looking for an insertion point
        next_ptr = pointerof(next_node)
        recursive_insert(next_node, next_ptr, key, value, depth+1)
        current.replace_child(key[depth], next_node)
      else
        # Add new leaf at the current position
        current.add_child(key[depth], CART.make_leaf_ptr(key, value))
        @size += 1
        return true
      end
    end

    # Convenience method for inserting a String into the tree
    def insert(value : String)
      insert(value, value)
    end

    # Insert a String into the tree where key and value are different
    def insert(key : String, value : String)
      insert(key.codepoints, value.codepoints)
    end

    # Return the value of the node that contains the provided key,
    # or nil if not found
    def search(key : Array(Int32))
      ensure_null_terminated(key)
      recursive_search(@root, key, 0)
    end

    # Recursive search helper function that traverses the tree.
    # Returns the value of the node that contains the passed in key, or nil if not found.
    def recursive_search(current_ptr, key, depth)
      return nil if current_ptr.nil? || current_ptr.null?
      current = current_ptr.value

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
      recursive_search(current.find_child(key[depth]), key, depth+1)
    end

    # Convenience method for search the tree with a String
    def search(key : String)
      search(key.codepoints)
    end

    # Return the node that contains the provided key,
    # or nil if not found
    def find_node(key : Array(Int32))
      ensure_null_terminated(key)
      recursive_find_node(@root, key, 0)
    end

    # Recursive search helper function that traverses the tree.
    # Returns the node that contains the passed in key, or nil if not found.
    def recursive_find_node(current_ptr, key, depth)
      return nil if current_ptr.nil? || current_ptr.null?
      current = current_ptr.value

      # If we are looking at a leaf node try to match the given key
      if current.leaf?
        if current.matches_key?(key)
          return current
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
      recursive_find_node(current.find_child(key[depth]), key, depth+1)
    end

    # Convenience method for finding a node given a String
    def find_node(key : String)
      find_node(key.codepoints)
    end

    # Execute given block for each node in prefix order
    def each(&block : Pointer(Node) -> _)
      recursive_each(@root, &block)
    end

    def recursive_each(node_ptr, &block : Pointer(Node) -> _)
      return if node_ptr.nil? || node_ptr.null?

      # Call given block for current node
      block.call(node_ptr)

      # if current node is an innner node, recursively call each for every child
      unless node_ptr.value.leaf?
        node_ptr.value.children.each do |c|
          recursive_each(c, &block)
        end
      end
    end

    # Helper method that null terminates a given key
    def ensure_null_terminated(key : Array(Int32))
      key << 0 if key.index(0).nil?
    end

    # For convenience, allow calling directly with a String
    def ensure_null_terminated(key : String)
      ensure_null_terminated(key.codepoints)
    end
  end
end