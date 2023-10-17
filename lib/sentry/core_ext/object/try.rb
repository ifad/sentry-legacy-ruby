class Object
  def try(method_name, *args)
    return nil unless respond_to?(method_name)

    public_send(method_name, *args)
  end
end

class NilClass
  def try(*args)
    nil
  end
end
