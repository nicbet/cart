require "./spec_helper"

describe CART::Tree do
  it "can be instantiated and an empty tree is size 0 with a null root" do
    tree = CART::Tree.new
    tree.root.null?.should be_true
    tree.size.should eq(0)
  end

  it "has a none-null root after a single insert operation and size is 1" do
    tree = CART::Tree.new
    tree.insert("hello", "world")

    tree.root.null?.should be_false
    tree.size.should eq(1)
  end

  it "allows us to insert a value and uses that value as key" do
    tree = CART::Tree.new
    tree.insert("cat")

    tree.root.null?.should be_false
    tree.size.should eq(1)
    tree.root.leaf?.should be_true
    tree.root.as(CART::Leaf).value.should eq("cat")
    tree.root.as(CART::Leaf).key_str.should eq("cat")
  end

  it "inserts multiple values with a common prefix" do
    tree = CART::Tree.new
    tree.insert("cat")
    tree.insert("car")
    tree.insert("cap")

    tree.size.should eq(3)
    tree.root.inner_node?.should be_true
    tree.root.node4?.should be_true
    tree.root.as(CART::Node4).prefix_len.should eq(2)
    tree.root.as(CART::Node4).prefix.to_str.should eq("ca")
  end

  it "should be able to retrieve the inserted term via search after single insert operation" do
    tree = CART::Tree.new
    tree.insert("hello", "world")
    tree.search("hello").should eq("world")
  end

  it "should be able to retrieve previously inserted values after inserting twice and causing root to grow" do
    tree = CART::Tree.new
    tree.insert("hello", "world")
    tree.insert("yo", "earth")

    tree.search("yo").should eq("earth")
    tree.search("hello").should eq("world")
  end

  it "should be searchable after inserting two leafs with similar prefix" do
    tree = CART::Tree.new
    tree.insert("a", "a")
    tree.insert("aa", "aa")

    tree.search("a").should eq("a")
    tree.search("aa").should eq("aa")
  end

  it "a node with similar prefix should be split into new nodes and be searchable" do
    tree = CART::Tree.new
    tree.insert("A")
    tree.insert("a")
    tree.insert("aa")

    tree.search("a").should eq("a")
    tree.search("aa").should eq("aa")
    tree.search("A").should eq("A")
  end
end