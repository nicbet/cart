require "./cart/*"
require "./util/*"

module CART
  # Aliases
  alias UInt8_4 = StaticArray(UInt8, 4)
  alias UInt8_16 = StaticArray(UInt8, 16)
  alias UInt8_256 = StaticArray(UInt8, 256)

  alias Node_4 = StaticArray(Node, 4)
  alias Node_16 = StaticArray(Node, 16)
  alias Node_48 = StaticArray(Node, 48)
  alias Node_256 = StaticArray(Node, 256)

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

  def self.make_null_node
    return CART::Node.new(CART::NodeType::None)
  end

  def self.make_node4
    node = CART::Node.new(CART::NodeType::Node4)
    node.keys = Array(Int32).new(4, 0)
    node.children = Array(Pointer(Node)).new(4, Pointer(Node).null)
    return node
  end

  def self.make_node4_ptr
    node_ptr = Pointer(Node).malloc
    node_ptr.value = make_node4
    return node_ptr
  end

  def self.make_leaf(key : Array(Int32), value : Array(Int32))
    node = CART::Node.new(CART::NodeType::Leaf)
    node.key = key
    node.value = value
    return node
  end

  def self.make_leaf(key : String, value : String)
    make_leaf(key.codepoints, value.codepoints)
  end

  def self.make_leaf(value : String)
    make_leaf(value.codepoints, value.codepoints)
  end

  def self.make_leaf_ptr(key : Array(Int32), value : Array(Int32))
    node_ptr = Pointer(Node).malloc
    node_ptr.value = make_leaf(key, value)
    return node_ptr
  end
end
