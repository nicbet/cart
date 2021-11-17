require "./cart/*"

module CART
  #  Constants
  # Inner nodes of size 4
  NODE_4_MIN = 2
  NODE_4_MAX = 4

  # Inner nodes of size 16
  NODE_16_MIN = 5
  NODE_16_MAX = 16

  # Inner nodes of size 48
  NODE_48_MIN = 17
  NODE_48_MAX = 48

  # Inner nodes of size 256
  NODE_256_MIN = 49
  NODE_256_MAX = 256

  #  PREFIX LENGTH
  MAX_PREFIX_LEN = 10

  def self.make_leaf(key, value)
    node = Node.new
    node.node_type = NodeType::Leaf
    node.key = key
    node.value = value

    return node
  end

  def self.make_node4
    node = Node.new
    node.node_type = NodeType::Node4

    return node
  end

  def self.make_node16
    node = Node.new
    node.node_type = NodeType::Node16

    return node
  end

  def self.make_node48
    node = Node.new
    node.node_type = NodeType::Node48

    return node
  end

  def self.make_node256
    node = Node.new
    node.node_type = NodeType::Node256

    return node
  end
end
