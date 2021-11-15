module CART
  class Key(T)
    def initialize(@value : T)
    end

    def value
      @value
    end
  end
end
