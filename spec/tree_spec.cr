require "./spec_helper"

describe CART::Tree do
  it "can be instantiated" do
    tree = CART::Tree.new
    tree.root.null?.should eq(true)
    tree.size.should eq(0)
  end

  it "inserts a k,v into an empty tree as a single Leaf node" do
    tree = CART::Tree.new
    tree.insert("foo", "bar")
    tree.size.should eq(1)
    tree.root.leaf?.should eq(true)
  end

  it "finds the value corresponding to the given key if leaf node exists" do
    tree = CART::Tree.new
    tree.insert("foo", "bar")
    tree.search("foo").should eq("bar")
  end

  it "contains a Node4 as the root node with 2 Leaf node children after inserting two k,v" do
    tree = CART::Tree.new
    tree.insert("fat", "fat")
    tree.insert("far", "far")
    tree.root.node4?.should eq(true)
    tree.root.prefix_len.should eq(2)
    tree.root.prefix.should eq("fa".to_slice)
  end
end