# using the ruby/rails compatibility matrix I have taken the implementation of AS 4.2.11.3
# 4.2.11.3 (ruby.2.2 reccomended) < 5 (ruby 2.4 reccomended => min sentry official version)

class Object
  def try(*a, &b)
    try!(*a, &b) if a.empty? || respond_to?(a.first)
  end

  # Same as #try, but will raise a NoMethodError exception if the receiver is not +nil+ and
  # does not implement the tried method.

  def try!(*a, &b)
    if a.empty? && block_given?
      if b.arity == 0
        instance_eval(&b)
      else
        yield self
      end
    else
      public_send(*a, &b)
    end
  end
end

class NilClass
  def try(*args)
    nil
  end

  def try!(*args)
    nil
  end

end
