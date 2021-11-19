require "./spec_helper"

describe CART::Node4 do
  it "can be instantiated" do
    node = CART::Node4.new

    node.node4?.should eq(true)
    node.inner_node?.should eq(true)
    node.full?.should eq(false)
    node.min_size.should eq(CART::NODE_4_MIN)
    node.max_size.should eq(CART::NODE_4_MAX)
  end

  it "should insert a Leaf node into an empty Node4" do
    node = CART::Node4.new
    l = CART::Leaf.new("foo", "bar")

    node.add_child(1, l)

    node.size.should eq(1)
    node.keys.should eq(StaticArray[1,0,0,0])
    node.children[0].should eq(l)
  end

  it "should insert two Leaf nodes into an empty Node4" do
    node = CART::Node4.new
    l1 = CART::Leaf.new("foo", "bar")
    l2 = CART::Leaf.new("foo", "baz")

    node.add_child(2, l1)
    node.add_child(1, l2)

    node.size.should eq(2)
    node.keys.should eq(StaticArray[1,2,0,0])
    node.children[0].should eq(l2)
    node.children[1].should eq(l1)
  end

  it "should find the smallest child leaf as minimum" do
    node = CART::Node4.new
    l1 = CART::Leaf.new("foo", "bar")
    l2 = CART::Leaf.new("foo", "baz")

    node.add_child(2, l1)
    node.add_child(1, l2)

    node.min.should eq(l2)
  end

  it "should return nil as the min when no leaf nodes in subtree" do
    node = CART::Node4.new

    node.min.should eq(nil)
  end

  it "should find the largest child leaf as max" do
    node = CART::Node4.new
    l1 = CART::Leaf.new("bar", "bar")
    l2 = CART::Leaf.new("baz", "baz")

    node.add_child('r', l1)
    node.add_child('z', l2)

    node.max.should eq(l2)
  end

  it "should return nil as the max when no leaf nodes in subtree" do
    node = CART::Node4.new

    node.max.should eq(nil)
  end

  it "should find a child" do
    node = CART::Node4.new
    child = CART::Node4.new

    node.add_child('a', child)

    node.size.should eq(1)
    node.find_child('a').should eq(child)
    node.find_child(42).should eq(nil)
  end

  it "should preserve the prefix order of keys regardless of insertion order" do
    node = CART::Node4.new
    c1 = CART::Node4.new
    c2 = CART::Node4.new

    node.add_child('b', c2)
    node.add_child('a', c1)

    node.size.should eq(2)
    node.keys[0].should eq('a'.ord)
    node.keys[1].should eq('b'.ord)
  end

  it "should be able to add 4 child elements with different prefixes and perserve sorted order of keys" do
    node = CART::Node4.new
    c1 = CART::Node4.new
    c2 = CART::Node4.new
    c3 = CART::Node4.new
    c4 = CART::Node4.new

    node.add_child(97, c1)
    node.add_child(100, c4)
    node.add_child(98, c2)
    node.add_child(99, c3)

    node.size.should eq(4)
    node.keys.to_a.should eq([97, 98, 99, 100])
  end

  it "should not be full after inserting 1 child" do
    node = CART::Node4.new
    c1 = CART::Node4.new

    node.add_child(97, c1)
    node.full?.should be_false
  end

  it "should not be full after inserting 2 children" do
    node = CART::Node4.new
    c1 = CART::Node4.new
    c2 = CART::Node4.new

    node.add_child(97, c1)
    node.add_child(98, c2)
    node.full?.should be_false
  end

  it "should not be full after inserting 3 children" do
    node = CART::Node4.new
    c1 = CART::Node4.new
    c2 = CART::Node4.new
    c3 = CART::Node4.new

    node.add_child(97, c1)
    node.add_child(98, c2)
    node.add_child(99, c3)
    node.full?.should be_false
  end

  it "should be full after inserting 4 children" do
    node = CART::Node4.new
    c1 = CART::Node4.new
    c2 = CART::Node4.new
    c3 = CART::Node4.new
    c4 = CART::Node4.new

    node.add_child('a', c1)
    node.add_child('b', c2)
    node.add_child('c', c3)
    node.add_child('d', c4)
    node.full?.should be_true
  end

  it "should find the right index for a child" do
    node = CART::Node4.new
    c1 = CART::Node4.new
    c2 = CART::Node4.new
    c3 = CART::Node4.new
    c4 = CART::Node4.new

    node.add_child('q', c1)
    node.add_child('a', c2)
    node.add_child('g', c3)
    node.add_child('d', c4)

    node.index_for('a').should eq(0)
    node.index_for('d').should eq(1)
    node.index_for('g').should eq(2)
    node.index_for('q').should eq(3)

    node.index_for('z').should eq(-1)
  end

  it "finds the minimum child in a subtree" do
    node = CART::Node4.new
    c1 = CART::Node4.new
    c2 = CART::Node4.new

    l1 = CART::Leaf.new("foo", "foo")
    l2 = CART::Leaf.new("bar", "bar")

    c1.add_child('o', l1)
    c2.add_child('a', l2)

    node.add_child('f', c1)
    node.add_child('b', c2)

    node.min.should eq(l2)
  end

  it "finds the maximum child in a subtree" do
    node = CART::Node4.new
    c1 = CART::Node4.new
    c2 = CART::Node4.new

    l1 = CART::Leaf.new("foo", "foo")
    l2 = CART::Leaf.new("bar", "bar")

    c1.add_child('o', l1)
    c2.add_child('a', l2)

    node.add_child('f', c1)
    node.add_child('b', c2)

    node.max.should eq(l1)
  end

  it "should correctly copy metadata from another node" do
    other = CART::Node4.new
    other.prefix = [102, 111]
    other.prefix_len = 2
    other.add_child('o', CART::Leaf.new("foo","foo"))
    other.add_child('p', CART::Leaf.new("fop","fop"))

    node = CART::Node4.new
    node.copy_meta(other)

    node.size.should eq(2)
    node.prefix_len.should eq(2)
    node.prefix.should eq([102, 111])
  end
end
