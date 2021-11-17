module CART
  # Node Types
  enum NodeType
    None
    Node4
    Node16
    Node48
    Node256
    Leaf

    def node4?
      self == NodeType::Node4
    end

    def node16?
      self == NodeType::Node16
    end

    def node48?
      self == NodeType::Node48
    end

    def node256?
      self == NodeType::Node256
    end

    def leaf?
      self == NodeType::Leaf
    end

    def inner_node?
      self == NodeType::Node4 || self == NodeType::Node16 || self == NodeType::Node48 || self == NodeType::Node256
    end
  end
end