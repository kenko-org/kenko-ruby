module Kenko
  class Container
    # TODO: use mutex here
    def self.register(check_name, &block)
      if key(check_name)
        raise Error, "There is already an item registered with the key #{check_name.inspect}"
      else
        _container[check_name.to_sym] = block
      end
    end

    # TODO: options: raise - ok if zero erros, bad - if raises error
    def self.resolver(check_name)
      if key(check_name)
        key(check_name).call
      else
        raise Error, "Nothing registered with the key #{check_name.inspect}"
      end
    end

    def self.keys
      _container.keys
    end

    def self.flush
      @@container = {}
    end

  private

    def self.key(name)
      _container[name.to_sym]
    end

    def self._container
      @@container ||= {}
    end
  end
end
