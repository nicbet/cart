require "./spec_helper"

describe CART::Node16 do
  it "can be instantiated" do
    node = CART::Node16.new

    node.node16?.should eq(true)
    node.inner_node?.should eq(true)
    node.full?.should eq(false)
    node.min_size.should eq(CART::NODE_16_MIN)
    node.max_size.should eq(CART::NODE_16_MAX)
  end

  it "should insert a leaf node when empty" do
    node = CART::Node16.new
    l = CART::Leaf.new("foo", "bar")

    node.add_child(1, l)

    node.size.should eq(1)
    node.keys.should eq(StaticArray[1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0])
  end
end
