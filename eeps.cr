
abstract class AbsHash
end

class HashWrap(K, V) < AbsHash
    property items : Hash(K, V)

    def initialize
        @items = Hash(K, V).new
    end

    def set(k : K, v : V)
        @items[k] = v
    end

    def has(k : K)
        @items.has_key(k)
    end

    def get(k : K)
        @items[k]
    end

    def remove(k : K)
        @items.delete(k)
    end

    def get?(k : K)
        if has(k)
            get(k)
        else
            nil
        end
    end

    def remove?(k : K)
        if has(k)
            remove(k)
            true
        else
            nil
        end
    end
end


class EntHash(V) < HashWrap(Int32, V)
end


abstract class AbsFunc
    property comps : HashWrap(String, EntHash(AbsComp))
    property funcs : HashWrap(String, AbsFunc)

    def initialize(a : Tuple(HashWrap(String, EntHash(AbsComp)), HashWrap(String, AbsFunc)))
        @comps = a[0]
        @funcs = a[1]
    end

    def exec(i : Int32)
    end
end


abstract class AbsProc < AbsFunc
    # Processes are the core of eeps,
    # An implementation of Engines from ECS with the addition of being a
    # component container and the ability to iterate over it.
    # Each process is connected to a Engine of processes.
    
    property running : Bool

    def initialize(a : Tuple(HashWrap(String, EntHash(AbsComp)), HashWrap(String, AbsFunc)))
        super(a)
        @running = false
    end

    def start
        @running = true
    end

    def stop
        @running = false
    end
end


abstract class AbsComp
end

class Entity < AbsFunc
    property index : Int32
    property free : Array(Int32)
    property components : EntHash(Array(String)) 

    def initialize(a : Tuple(HashWrap(String, EntHash(AbsComp)), HashWrap(String, AbsFunc)))
        super(a)
        @index = 0
        @free = Array(Int32).new
        @components = EntHash(Array(String)).new
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

        value
    end
    
    def remove(index : Int32)
        @free.delete(index)
        free << index
    end
end    

class Engine   
    # Engine of processes
    # This is sometimes called a World in other ECS implemenations
    # It allows easy access of processess between each other.
    # Automatically implements a component process and an entity process.
    
    property comps : HashWrap(String, EntHash(AbsComp))
    property funcs : HashWrap(String, AbsFunc)
    property procs : HashWrap(String, AbsProc)
    property entity : Entity
    property args : Tuple(HashWrap(String, EntHash(AbsComp)), HashWrap(String, AbsFunc))

    def initialize
        @comps = HashWrap(String, EntHash(AbsComp)).new
        @funcs = HashWrap(String, AbsFunc).new
        @procs = HashWrap(String, AbsProc).new
        @args = Tuple.new(@comps, @funcs)
        @entity = Entity.new(@args)
    end

    def run
        @procs.items.each do |proc|
            proc[1].run
        end
    end
end




