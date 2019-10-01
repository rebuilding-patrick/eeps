
require "./pairlist"


class CompList(V) < PairList(Int32, V)
end


abstract class AbsFunc
    property comps : PairList(String, CompList(AbsComp))
    property funcs : PairList(String, AbsFunc)

    def initialize(a : Tuple(PairList(String, CompList(AbsComp)), PairList(String, AbsFunc)))
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

    def initialize(a : Tuple(PairList(String, CompList(AbsComp)), PairList(String, AbsFunc)))
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
    property components : CompList(Array(String)) 

    def initialize(a : Tuple(PairList(String, CompList(AbsComp)), PairList(String, AbsFunc)))
        super(a)
        @index = 0
        @free = Array(Int32).new
        @components = CompList(Array(String)).new
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
    
    property comps : PairList(String, CompList(AbsComp))
    property funcs : PairList(String, AbsFunc)
    property procs : PairList(String, AbsProc)
    property entity : Entity
    property args : Tuple(PairList(String, CompList(AbsComp)), PairList(String, AbsFunc))

    def initialize
        @comps = PairList(String, CompList(AbsComp)).new
        @funcs = PairList(String, AbsFunc).new
        @procs = PairList(String, AbsProc).new
        @args = Tuple.new(@comps, @funcs)
        @entity = Entity.new(@args)
    end

    def run
        @procs.values.each do |proc|
            proc.run
        end
    end
end


