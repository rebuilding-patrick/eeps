from eeps import *

import sys
from random import randint


"""
Defining some components.
Components are objects that store data with ideally no functionality
eeps lets you add methods if you want though. We won't tell. We don't care.
"""
class Position:
    def __init__(self, x, y):
        self.x = x
        self.y = x


class Name:
    def __init__(self, name):
        self.name = name
        

"""
Customizing the processess.
Each process is connected to a system of processes and has a dictionary of
components indexed by entity that it manages and can process over.
In a traditional ecs implemenation these are the systems.
"""
class Heading(Process):
    def __init__(self, system):
        Process.__init__(self, system)

        
class Spatial(Process):
    def __init__(self, system):
        Process.__init__(self, system)

    def update(self, index):
        direction = self.system.heading.hget(index)
        if direction:
            position = self.items[index]
            position.x += direction.x
            position.y += direction.y


"""
Processess don't have to process, they can just be data containers
"""
class Nominal(Process):
    def __init__(self, system):
        Process.__init__(self, system)


class Visual(Process):
    def __init__(self, system):
        Process.__init__(self, system)

    def update(self, index):
        name = self.system.nominal.get(index)
        position = self.system.spatial.get(index)
        print(f'{index}/{name.name}/{position.x}:{position.y}  ')


"""
Creating a system for components to join.
The system must be created first for processes to join
"""
system = System()

"""
Adding to the system directly instead of to its list for a custom loop
Could use system.add('spatial', spatial) for a more generic interation
"""
system.component = Component(system)
system.entity = Entity(system)
system.spatial = Spatial(system)
system.heading = Heading(system)
system.nominal = Nominal(system)
system.visual = Visual(system)

"""
Putting uninstanced components into their systems to easily define entities.
"""
system.component.add('name', Name)
system.component.add('position', Position)


"""
Creating an entity
"""
def create_entity(name, x, y, dx, dy):
    """
    Begin by spawning an index from the entity process.
    """
    index = system.entity.add()

    """
    Instantiate the components
    """
    name = system.component.get('name')(name)
    position = system.component.get('position')(x, y)
    direction = system.component.get('position')(dx, dy)

    """
    Add the component instances to their processess
    """
    system.nominal.add(index, name)
    system.spatial.add(index, position)
    system.heading.add(index, direction)

    """
    You can add arbitary data to processess
    """
    system.visual.add(index, True)

    return index


"""
Making some random entities.
"""
def random_entity():
    rn = randint(0, sys.maxsize)
    rx = randint(0, 100)
    ry = randint(0, 100)
    rdx = randint(-1, 1)
    rdy = randint(-1, 1)

    return create_entity(rn, rx, ry, rdx, rdy)
    

for i in range(10):
    random_entity()


"""
Defining the custom interation for the system
"""
def loop():
    system.spatial.run()
    system.visual.run()

"""
Run it a few times
"""
for i in range(20):
    print(f'Turn #{i}')
    loop()
    
