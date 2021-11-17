require "./spec_helper"

describe CART::Node do
  it "makes a Node4" do
    node = CART.make_node4

    node.node4?.should eq(true)
    node.inner_node?.should eq(true)
    node.full?.should eq(false)
    node.min_size.should eq(CART::NODE_4_MIN)
    node.max_size.should eq(CART::NODE_4_MAX)
  end

  it "makes a Node16" do
    node = CART.make_node16

    node.node16?.should eq(true)
    node.inner_node?.should eq(true)
    node.full?.should eq(false)
    node.min_size.should eq(CART::NODE_16_MIN)
    node.max_size.should eq(CART::NODE_16_MAX)
  end

  it "makes a Node48" do
    node = CART.make_node48

    node.node48?.should eq(true)
    node.inner_node?.should eq(true)
    node.full?.should eq(false)
    node.min_size.should eq(CART::NODE_48_MIN)
    node.max_size.should eq(CART::NODE_48_MAX)
  end

  it "makes a Node256" do
    node = CART.make_node256

    node.node256?.should eq(true)
    node.inner_node?.should eq(true)
    node.full?.should eq(false)
    node.min_size.should eq(CART::NODE_256_MIN)
    node.max_size.should eq(CART::NODE_256_MAX)
  end

  it "makes a Leaf" do
    node = CART.make_leaf("foo", "bar")

    node.leaf?.should eq(true)
    node.inner_node?.should eq(false)
    node.value.should eq("bar")
  end

  it "should insert" do
    node = CART.make_node4
    l = CART.make_leaf("foo", "bar")
    node.add_child(1, pointerof(l))

    node.size.should eq(1)
    node.keys[0].should eq(1)
    node.children[0].should eq(pointerof(l))
  end
end
