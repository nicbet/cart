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
    l1 = CART::Leaf.new("foo", "bar")
    l2 = CART::Leaf.new("foo", "baz")

    node.add_child(2, l1)
    node.add_child(1, l2)

    node.max.should eq(l1)
  end

  it "should return nil as the max when no leaf nodes in subtree" do
    node = CART::Node4.new

    node.max.should eq(nil)
  end
end
