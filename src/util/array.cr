class Array(T)
  def to_str
    raise "Only Supported for Array(Int32)" unless self.is_a?(Array(Int32))
    self.map { |x| x.chr }.join
  end
end