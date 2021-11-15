require "./spec_helper"

describe CART do
  it "a new tree as a nil root and size 0" do
    tree = CART::Tree.new
    tree.root.should eq(nil)
    tree.size.should eq(0)
  end

  it "inserts a new value into an empty tree as a leaf node" do
    tree = CART::Tree.new
    tree.insert("k", "v")

    tree.root.is_a?(CART::Leaf).should eq(true)

    node = tree.root.as(CART::Leaf)
    node.key.should eq("k")
    node.value.should eq("v")
  end

  it "replace the existing leaf node value in a single node tree when we insert a new value and the key is the same" do
    tree = CART::Tree.new
    tree.insert("k", "v")
    tree.insert("k", "z")
    node = tree.root.as(CART::Leaf)
    node.key.should eq("k")
    node.value.should eq("z")
  end

  it "splits a leaf node into a Node4" do
    tree = CART::Tree.new
    tree.insert("a", "1")
    tree.insert("b", "2")
    tree.root.is_a?(CART::Node4).should eq(true)
  end
end
