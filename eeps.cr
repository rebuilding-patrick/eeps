
struct Component
end

class Process
    
    # Processes are the core of eeps,
    # An implementation of Engines from ECS with the addition of being a
    # component container and the ability to iterate over it.
    # Each process is connected to a Engine of processes.
    
    property engine : Engine
    property items : Hash(Int32, Component) 

    def initialize(engine : Engine)
        @engine = Engine
        @items = Hash(Int32, Component).new
    end

    def start
    end

    def run
        @items.each_value do |i|
            update(i)
        end
    end

    def update(index : Int32)
    end

    def set(index : Int32, value : Component)
        @items[index] = value
    end

    def has(index : Int32)
        @items.has_key(index)
    end

    def get(index : Int32)
        @items[i]
    end

    def remove(index : Int32)
        @item.remove(index)
    end

    def hget(index : Int32)
        if has(index)
            get(index)
        else
            nil
        end
    end

    def hremove(index : Int32)
        if has(index)
            remove(index)
            true
        else
            false
        end
    end

    def stop
    end
end

class Entity < Process
    
    # The Entity Process. Again, not an entity class as they are simple ints.
    # Keeps track of the entities in the Engine.

    property index : Int32
    property free : Array(Int32)

    def initialize(engine : Engine)
        super(engine)
        self.index = 0
        self.free = Array(Int32).new
    end

    def add
        value : Int32
        if @free.size > 0
            value = @free[-1]
            @free.pop
        else
            value = @index
            @index += 1
        end

        set(value, True)
        value
    end

    def remove(index : Int32)
        remove(index)
        free << index
    end
end

class Engine < Process
    
    # Engine of processes
    # This is sometimes called a World in other ECS implemenations
    # It allows easy access of processess between each other.
    # Automatically implements a component process and an entity process.
    
    property component : Process
    property entity : Entity

    def initialize
        super(self)
        @component = Process.new(self)
        @entity = Entity.new(self)
    end

    def initialize(engine : Engine)
        super(self)
        @component = Process.new(self)
        @entity = Entity.new(self)
    end
end