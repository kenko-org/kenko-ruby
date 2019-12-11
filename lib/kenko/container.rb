module Kenko
  class Container
    def self.register(check_name, &block)
      if _container[check_name]
        raise Error, "There is already an item registered with the key #{check_name.inspect}"
      else
        _container[check_name] = block
      end
    end

    def self.resolver(check_name)
      if _container[check_name]
        _container[check_name].call
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

    def self._container
      @@container ||= {}
    end
  end
end
