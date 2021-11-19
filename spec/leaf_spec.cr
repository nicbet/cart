require "./spec_helper"

describe CART::Leaf do

  it "a Leaf node correctly determines it is a leaf" do
    node = CART::Leaf.new("test", "test")
    node.leaf?.should be_true

    node4 = CART::Node4.new
    node4.leaf?.should be_false

    node16 = CART::Node16.new
    node16.leaf?.should be_false

    # node48 = CART::Node48.new
    # node48.leaf?.should be_false

    # node256 = CART::Node256.new
    # node256.leaf?.should be_false
  end

  it "correctly determines if it is a match or not" do
    leaf = CART::Leaf.new("test", "test")
    leaf.matches_key?("test").should be_true
    leaf.matches_key?("test2").should be_false
  end

  it "correctly retrieves its value" do
    leaf = CART::Leaf.new("test", "foo")
    leaf.value.should eq("foo")
  end

  it "returns itself as the subtree minimum" do
    leaf = CART::Leaf.new("test", "test")
    leaf.min.should eq(leaf)
  end

  it "returns itself as the subtree maximum" do
    leaf = CART::Leaf.new("test", "test")
    leaf.max.should eq(leaf)
  end

  it "correctly determines the longest common prefix with another node at a given depth" do
    node1 = CART::Leaf.new("amazIng", "amazIng")
    node2 = CART::Leaf.new("amazOnian", "amazOnian")

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

  it "grows into a Node4" do
    true
  end
end