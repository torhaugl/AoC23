import numpy as np


def read_input(fname):
    with open(fname, 'r') as f:
        data = f.read()

    map = np.array([list(line) for line in data.strip().split('\n')])
    return map


def read_input(fname):
    with open(fname, 'r') as f:
        data = f.read()

    map = np.array([list(line) for line in data.strip().split('\n')])
    for i in range(np.size(map, 0)):
        for j in range(np.size(map, 1)):
            if map[i,j] != '#':
                map[i,j] = '.'

    return map

def get_neighbor(map, index):
    neighbors = []

    now = map[index]
    if now != '.':
        if now == '<':
            neighbors.append((index[0], index[1]-1))
        elif now == '>':
            neighbors.append((index[0], index[1]+1))
        elif now == '^':
            neighbors.append((index[0]-1, index[1]))
        elif now == 'v':
            neighbors.append((index[0]+1, index[1]))
        elif now == '#':
            raise Exception(f"Stepping on # is illegal. Pos {index}")
        else:
            raise Exception(f"Did not recognize location. {now}")
        return neighbors

    for delta in [(-1,0), (+1,0), (0,-1), (0,+1)]:
        neighbor_index = (index[0] + delta[0], index[1] + delta[1])
        try:
            char = map[neighbor_index]
            if char != '#':
                neighbors.append(neighbor_index)
        except IndexError:
            continue
    return neighbors


class Node:
    def __init__(self, index, previous = None):
        self.index = index
        self.previous = previous
    def edges(self):
        return get_neighbor(map, self.index)
    def __str__(self) -> str:
        return f"{self.previous} {self.index}"


def dfs_start(G, start, goal):
    node = Node(start)
    explored = set()
    scores = []
    dfs(G, node, explored, goal, scores)
    return scores

def dfs(G, v, explored, goal, scores):
    explored.add(v.index)

    if v.index == goal:
        i = 0
        while v.previous:
            v = v.previous
            i += 1
        print(i)
        scores.append(i)
        return None

    #to_return = []
    for index in v.edges():
        if index not in explored:
            new_explored = explored.copy()
            node = Node(index, v)
            new_explored.add(index)
            dfs(G, node, new_explored, goal, scores)
#           Return first answer only
#            if g:
#                return g
#            for x in g:
#                if x not in to_return:
#                    to_return.append(x)

    #return to_return


if __name__ == "__main__":
    import sys
    print(sys.getrecursionlimit())
    sys.setrecursionlimit(10000)
    #print(sys.getrecursionlimit())

    start = (0, 1)
    #map = read_input("test")
    #goal = (22, 21) # test
    map = read_input("input")
    goal = (140, 139) # input
    print(map[start])
    print(get_neighbor(map, start))
    print(get_neighbor(map, goal))
    vs = dfs_start(map, start, goal)

    print("MAX")
    print(max(vs))

