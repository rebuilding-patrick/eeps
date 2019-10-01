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
    property name : EntHash(AbsComp)

    def initialize(args)
        super(args)
        @name = @comps.items["name"]
    end

    def exec(i : Int32)
        @name.items[i].as(Name).name
    end
end

class Movement < AbsProc
    property direction : EntHash(AbsComp)
    property spatial : EntHash(AbsComp)
    

    def initialize(args)
        super(args)
        @direction = @comps.items["direction"]
        @spatial = @comps.items["spatial"]
    end

    def run
        @direction.items.each do |e|
            d = spatial.items[e[0]].as(Position)
            p = e[1].as(Position)
            d.x += p.x
            d.y += p.y
        end
    end
end 


class Visual < AbsProc
    property visible : EntHash(AbsComp)
    property spatial : EntHash(AbsComp)
    
    property nominal : AbsFunc

    def initialize(args)
        super(args)
        @visible = @comps.items["visible"]
        @spatial = @comps.items["spatial"]
        
        @nominal = @funcs.items["nominal"]
    end

    def run
        @visible.items.each do |e|
            n = @nominal.exec(e[0])
            s = @spatial.get(e[0]).as(Position)
            puts "#{n}: #{s.x}, #{s.y}"
        end
    end
end

engine.comps.set("name", EntHash(AbsComp).new)
engine.comps.set("direction", EntHash(AbsComp).new)
engine.comps.set("spatial", EntHash(AbsComp).new)
engine.comps.set("visible", EntHash(AbsComp).new)

engine.funcs.set("nominal", Nominal.new(engine.args))

engine.procs.set("visual", Visual.new(engine.args))
engine.procs.set("movement", Movement.new(engine.args))


def create_entity(engine : Engine, n : String, x : Int32, y : Int32, dx : Int32, dy : Int32)
    index = engine.entity.add

    name = Name.new(n)
    position = Position.new(x, y)
    direction = Position.new(dx, dy)
    visible = Visible.new(true)

    engine.comps.items["name"].set(index, name)
    engine.comps.items["spatial"].set(index, direction)
    engine.comps.items["direction"].set(index, position)
    engine.comps.items["visible"].set(index, visible)

    index
end

r = Random.new

def random_entity(e : Engine, r : Random)
    rn = r.rand(1000).to_s
    rx = r.rand(100)
    ry = r.rand(100)
    rdx = r.rand(2) - 1
    rdy = r.rand(2) - 1

    create_entity(e, rn, rx, ry, rdx, rdy)
end


(0..2).each do |c|
    (0..2).each do |i|
        puts random_entity(engine, r)
    end
    
    #(3..6).each do |i|
    #    puts "Removing #{i}"
    #    engine.entity.remove(i)
    #end
end


(0..5).each do |i|
    puts "Turn #{i}"
    engine.run
end
    
