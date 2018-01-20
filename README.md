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

```crystal
require "cart"
```

TODO: Write usage instructions here

## Development

TODO: Write development instructions here

## Contributing

1. Fork it ( https://github.com/[nicbet]/cart/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [[nicbet]](https://github.com/[nicbet]) Nicolas Bettenburg - creator, maintainer
