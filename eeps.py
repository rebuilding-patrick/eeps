from threading import Thread


class Process:
    """
    Processes are the core of eeps,
    An implementation of Systems from ECS with the addition of being a
    component container and the ability to iterate over it.
    Each process is connected to a system of processes.
    """
    def __init__(self, system):
        self.system = system
        self.items = {}

    def start(self):
        return

    def _run(self):
        for i in self.items:
            self.update(i)

    def run(self):
        self._run()

    def update(self, index):
        return

    def _set(self, index, value):
        self.items[index] = value

    def set(self, index, value):
        self._set(index, value)

    def add(self, index, value):
        self._set(index, value)

    def _has(self, index):
        return index in self.items

    def has(self, index):
        return self._has(index)

    def _get(self, index):
        return self.items[index]

    def get(self, index):
        return self._get(index)

    def _remove(self, index):
        del self.items[index]

    def remove(self, index):
        self._remove(index)

    def hget(self, index):
        if self.has(index):
            return self.get(index)
        else:
            return False

    def hremove(self, index):
        if self.has(index):
            self.remove(index)
            return True
        else:
            return False

    def stop(self):
        return


class System(Process):
    """
    System of processes
    This would be the World or Engine used in most ECS implemenations
    It allows easy access of processess between each other.
    """

    def __init__(self):
        Process.__init__(self, self)


class ProcessThread(Process, Thread):
    """
    A process, but threaded
    """

    def __init__(self, system):
        Thread.__init__(self)
        Process.__init__(self, system)


class Component(Process):
    """
    This is the Component Process. It is not a component class, which don't
    need to have a parent type as they're just simple data containers. It
    keeps track of all of your components to easily access when
    creating an entity
    """
    def __init__(self, system):
        Process.__init__(self, system)


class Entity(Process):
    """
    The Entity Process. Again, not an entity class as they are simple ints.
    Keeps track of the entities in the system.
    """
    def __init__(self, system):
        Process.__init__(self, system)
        self.next = 0
        self.free = []

    def add(self):
        if self.free:
            value = self.free[0]
            self.free.remove(0)
        else:
            value = self.next
            self.next += 1

        self._set(value, True)
        return value

    def remove(self, index):
        self._remove(index)
        self.free.append(index)
