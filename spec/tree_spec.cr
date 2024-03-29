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

    tree.size.should eq(1)
    tree.root.null?.should be_false
    tree.root.value.leaf?.should be_true
    tree.root.value.key_str.should eq("hello")
    tree.root.value.value.should eq("world")
  end

  it "allows us to insert multiple values with common prefix" do
    tree = CART::Tree.new
    tree.insert("bee")
    tree.insert("bet")
    tree.insert("beg")

    tree.size.should eq(3)
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

  it "split a node with similar prefix into new nodes and be searchable" do
    tree = CART::Tree.new
    tree.insert("A")
    tree.insert("a")
    tree.insert("aa")

    tree.search("a").should eq("a")
    tree.search("aa").should eq("aa")
    tree.search("A").should eq("A")
  end

  it "should call each" do
    tree = CART::Tree.new
    tree.insert("acanthocarpous")
    tree.insert("Acanthocephala")
    tree.insert("acanthocephalan")

    puts "\n\n"
    tree.each do |n|
      puts n.value.value
    end
    puts "\n\n"
  end
end