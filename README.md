# Crystal-Lang Adaptive Radix Tree (CART)

This library provides an implementation of the Adaptive Radix Tree in Crystal.

Advantages of Adaptive Radix Trees:

- Lookup performance surpasses even highly tuned in-memory data structures
- Efficient insertions and deletions
- Highly space efficient with respect to height (complexity)
- Performance is equivalent to hash tables, O(k) but with better data locality
- O(k) search/insert/delete operations, where is k is the length of the key
- Minimum / Maximum value lookups
- Prefix based iteration

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  cart:
    github: [nicbet]/cart
```

## Usage

In your project require the library:

```crystal
require "cart"
```

Create a new adaptive radix tree with:

```crystal
tree = CART::Tree.new
```

Insert key, value pairs into the tree with:

```crystal
tree.insert("hello", "world")
```

Nodes will be stored in prefix order of the keys.

If you key and value is the same, you can simply do:

```crystal
tree.insert("animal")
```

and the node will store the same value for key and value.

You can retrieve a pointer to the `root` node of the tree with:

```crystal
tree.root
```

You can search for a value stored in the tree by the key that indexes that value:

```crystal
tree = CART::Tree.new
tree.insert("bee", "yellow")
tree.insert("honey", "amber")
tree.insert("nectar", "golden")

tree.search("honey")  # return "amber"
```

If you are interested in the full node that is stored in the tree by a given key:

```crystal
tree = CART::Tree.new
tree.insert("bee", "yellow")
tree.insert("honey", "amber")
tree.insert("nectar", "golden")

tree.find_node("honey")  # returns CART::Node(NodeType::Leaf)
```

You can walk the tree with the `.each` method that accepts a `Proc` and will call the given `Proc` for each node in the tree in prefix order:

```crystal
tree = CART::Tree.new
tree.insert("acanthocarpous")
tree.insert("Acanthocephala")
tree.insert("acanthocephalan")

tree.each do |n|
  puts n.value.value
end
```

## Contributing

1. Fork it ( https://github.com/[nicbet]/cart/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [[nicbet]](https://github.com/[nicbet]) Nicolas Bettenburg - creator, maintainer

## References

- The Adaptive Radix Tree: ARTful Indexing for Main-Memory Databases, by Viktor Leis, Alfons Kemper, Thomas Neumann, Technical University of Munich. [PDF](https://db.in.tum.de/~leis/papers/ART.pdf)
- Libart - Adaptive Radix Trees implemented in C, by Armon Dadgar with other contributors (Open Source, BSD 3-clause license). [Github](https://github.com/armon/libart)
- An adaptive radix tree implementation in GoLang by kellydunn. [Github](https://github.com/kellydunn/go-art)
