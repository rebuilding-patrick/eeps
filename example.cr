require "./eeps"


engine = Engine.new


class Position < AbsComp
    property x : Int32
    property y : Int32

    def initialize(x : Int32, y : Int32)
        @x = x
        @y = y
    end
end


class Name < AbsComp
    property name : String

    def initialize(n : String)
        @name = n
    end
end


class Visible < AbsComp
    property visible : Bool

    def initialize(v : Bool)
        @visible = v
    end
end


class Nominal < AbsFunc
    property name : CompList(Name)

    def initialize(args)
        super args
        @name = @comps.get("name").as CompList(Name)
    end

    def exec(i : Int32)
        @name.get(i).name
    end
end

class Movement < AbsProc
    property direction : CompList(Position)
    property spatial : CompList(Position)
    

    def initialize(args)
        super args
        @direction = @comps.get("direction").as CompList(Position)
        @spatial = @comps.get("spatial").as CompList(Position)
    end

    def run
        @direction.keys.each do |k|
            d = @spatial.get k
            p = @direction.get k
            d.x += p.x
            d.y += p.y
        end
    end
end 


class Visual < AbsProc
    property visible : CompList(Visible)
    property spatial : CompList(Position)
    property nominal : CompList(Name)

    def initialize(args)
        super(args)
        @visible = @comps.get("visible").as CompList(Visible)
        @spatial = @comps.get("spatial").as CompList(Position)
        @nominal = @comps.get("name").as CompList(Name)
    end

    def run
        @visible.keys.each do |k|
            n = @nominal.get(k)
            s = @spatial.get(k)
            puts "#{n.name}: #{s.x}, #{s.y}"
        end
    end
end

engine.comps.set "name", CompList(Name).new
engine.comps.set "direction", CompList(Position).new
engine.comps.set "spatial", CompList(Position).new
engine.comps.set "visible", CompList(Visible).new

engine.funcs.set "nominal", Nominal.new(engine.args)

engine.procs.set "visual", Visual.new(engine.args)
engine.procs.set "movement", Movement.new(engine.args)


def create_entity(engine : Engine, n : String, x : Int32, y : Int32, dx : Int32, dy : Int32)
    index = engine.entity.add

    name = Name.new n
    position = Position.new x, y
    direction = Position.new dx, dy
    visible = Visible.new true

    engine.comps.get("name").as(CompList(Name)).set index, name
    engine.comps.get("spatial").as(CompList(Position)).set index, direction
    engine.comps.get("direction").as(CompList(Position)).set index, position
    engine.comps.get("visible").as(CompList(Visible)).set index, visible

    index
end

r = Random.new

def random_entity(e : Engine, r : Random)
    rn = r.rand(1000).to_s
    rx = r.rand 100
    ry = r.rand 100
    rdx = r.rand(2) - 1
    rdy = r.rand(2) - 1

    create_entity e, rn, rx, ry, rdx, rdy
end


2.times do |c|
    2.times do |i|
        puts random_entity(engine, r)
    end
end


5.times do |i|
    puts "Turn #{i}"
    engine.run
end
    
