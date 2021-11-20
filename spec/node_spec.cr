require "./spec_helper"

describe CART::Node do
  it "can be instantiated into a Node4" do
    node = CART.make_node4

    node.node4?.should eq(true)
    node.inner_node?.should eq(true)
    node.full?.should eq(false)
    node.min_size.should eq(CART::NODE_4_MIN)
    node.max_size.should eq(CART::NODE_4_MAX)
  end

  it "a Node4 should insert a Leaf node into an empty Node4" do
    node = CART.make_node4
    leaf = CART.make_leaf("foo")

    node.add_child(1, pointerof(leaf))

    node.size.should eq(1)
    node.keys.should eq([1,0,0,0])
    node.children[0].should eq(pointerof(leaf))
    node.children[0].value.should eq(leaf)
  end

  it "a Node4 should insert two Leaf nodes into an empty Node4" do
    node = CART.make_node4
    l1 = CART.make_leaf("foo")
    l2 = CART.make_leaf("bar")

    node.add_child(2, pointerof(l1))
    node.add_child(1, pointerof(l2))

    node.size.should eq(2)
    node.keys.should eq([1,2,0,0])
    node.children[0].value.should eq(l2)
    node.children[1].value.should eq(l1)
  end

  it "a Node4 should find the smallest child leaf as minimum" do
    node = CART.make_node4
    l1 = CART.make_leaf("foo")
    l2 = CART.make_leaf("bar")

    node.add_child(2, pointerof(l1))
    node.add_child(1, pointerof(l2))

    node.min.should eq(l2)
  end

  it "a Node4 should return nil as the min when no leaf nodes in subtree" do
    node = CART.make_node4
    node.min.should eq(nil)
  end

  it "a Node4 should find the largest child leaf as maximum" do
    node = CART.make_node4
    l1 = CART.make_leaf("foo")
    l2 = CART.make_leaf("bar")

    node.add_child(2, pointerof(l1))
    node.add_child(1, pointerof(l2))

    node.max.should eq(l1)
  end

  it "a Node4 should return nil as the max when no leaf nodes in subtree" do
    node = CART.make_node4
    node.max.should eq(nil)
  end

  it "a Node4 should be able to find the minimum child in a sub-tree" do
    node = CART.make_node4
    child1 = CART.make_node4
    child2 = CART.make_node4
    leaf1 = CART.make_leaf("foo")
    leaf2 = CART.make_leaf("bar")

    child1.add_child('o', pointerof(leaf1))
    child2.add_child('a', pointerof(leaf2))

    node.add_child('f', pointerof(child1))
    node.add_child('b', pointerof(child2))

    node.min.should eq(leaf2)
  end

  it "a Node4 should be able to find the maximum child in a sub-tree" do
    node = CART.make_node4
    child1 = CART.make_node4
    child2 = CART.make_node4
    leaf1 = CART.make_leaf("foo")
    leaf2 = CART.make_leaf("bar")

    child1.add_child('o', pointerof(leaf1))
    child2.add_child('a', pointerof(leaf2))

    node.add_child('f', pointerof(child1))
    node.add_child('b', pointerof(child2))

    node.max.should eq(leaf1)
  end

  it "a Node4 should find a child" do
    node = CART.make_node4
    child = CART.make_node4

    node.add_child('a', pointerof(child))

    node.size.should eq(1)
    node.find_child('a').should eq(pointerof(child))
    node.find_child('z').should eq(nil)
  end

  it "a Node4 should preserve the prefix order of keys regardless of insertion order" do
    node = CART.make_node4
    child1 = CART.make_node4
    child2 = CART.make_node4

    node.add_child('b', pointerof(child2))
    node.add_child('a', pointerof(child1))

    node.size.should eq(2)
    node.keys[0].should eq('a'.ord)
    node.keys[1].should eq('b'.ord)
  end

  it "a Node4 should be able to add 4 child elements with different prefixes and perserve sorted order of keys" do
    node = CART.make_node4
    child1 = CART.make_node4
    child2 = CART.make_node4
    child3 = CART.make_node4
    child4 = CART.make_node4

    node.add_child('p', pointerof(child4))
    node.add_child('a', pointerof(child1))
    node.add_child('d', pointerof(child2))
    node.add_child('g', pointerof(child3))

    node.size.should eq(4)
    node.keys[0].should eq('a'.ord)
    node.keys[1].should eq('d'.ord)
    node.keys[2].should eq('g'.ord)
    node.keys[3].should eq('p'.ord)
  end

  it "a Node4 should be able to determine when the node is full" do
    node = CART.make_node4

    child1 = CART.make_node4
    node.add_child('a', pointerof(child1))
    node.full?.should be_false

    child2 = CART.make_node4
    node.add_child('b', pointerof(child2))
    node.full?.should be_false

    child3 = CART.make_node4
    node.add_child('c', pointerof(child3))
    node.full?.should be_false

    child4 = CART.make_node4
    node.add_child('d', pointerof(child4))
    node.full?.should be_true
  end

  it "a Node4 should find the right index for a child" do
    node = CART.make_node4

    child1 = CART.make_node4
    node.add_child('q', pointerof(child1))

    child2 = CART.make_node4
    node.add_child('a', pointerof(child2))

    child3 = CART.make_node4
    node.add_child('g', pointerof(child3))

    child4 = CART.make_node4
    node.add_child('d', pointerof(child4))

    node.index_for('a').should eq(0)
    node.index_for('d').should eq(1)
    node.index_for('g').should eq(2)
    node.index_for('q').should eq(3)

    node.index_for('z').should eq(-1)
  end

  it "a Node4 should correctly copy metadata from another node" do
    other = CART.make_node4
    leaf1 = CART.make_leaf("foo")
    leaf2 = CART.make_leaf("bar")

    other.prefix = [102, 111]
    other.prefix_len = 2
    other.add_child('o', pointerof(leaf1))
    other.add_child('p', pointerof(leaf2))

    node = CART.make_node4
    node.copy_meta(other)

    node.size.should eq(2)
    node.prefix_len.should eq(2)
    node.prefix.should eq([102, 111])
  end

  it "a Leaf node correctly determines that is a leaf" do
    leaf = CART.make_leaf("foo")
    leaf.leaf?.should be_true

    node4 = CART.make_node4
    node4.leaf?.should be_false

    # node16 = CART.make_node16
    # node16.leaf?.should be_false

    # node48 = CART.make_node48
    # node48.leaf?.should be_false

    # node256 = CART.make_node256
    # node256.leaf?.should be_false
  end

  it "a Leaf node correctly determines whether it matches a given key or not" do
    leaf = CART.make_leaf("test")
    leaf.matches_key?("test").should be_true
    leaf.matches_key?("test2").should be_false
  end

  it "a Leaf node correctly retrieves its value" do
    leaf = CART.make_leaf("test", "foo")
    leaf.value.should eq("foo")
  end

  it "a Leaf node returns itself as the subtree minimum" do
    leaf = CART.make_leaf("test")
    leaf.min.should eq(leaf)
  end

  it "a Leaf node returns itself as the subtree maximum" do
    leaf = CART.make_leaf("test")
    leaf.max.should eq(leaf)
  end

  it "a Leaf node correctly determines the longest common prefix with another node at a given depth" do
    node1 = CART.make_leaf("amazIng")
    node2 = CART.make_leaf("amazOnian")

    node1.longest_common_prefix(node2, 0).should eq(4)
    node1.longest_common_prefix(node2, 1).should eq(3)
    node1.longest_common_prefix(node2, 2).should eq(2)
    node1.longest_common_prefix(node2, 3).should eq(1)
    node1.longest_common_prefix(node2, 4).should eq(0)

    node2.longest_common_prefix(node1, 0).should eq(4)
    node2.longest_common_prefix(node1, 1).should eq(3)
    node2.longest_common_prefix(node1, 2).should eq(2)
    node2.longest_common_prefix(node1, 3).should eq(1)
    node2.longest_common_prefix(node1, 4).should eq(0)
  end

end