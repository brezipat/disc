from collections import defaultdict
from queue import PriorityQueue
from typing import List, Tuple


class Graph:
    class _Vertex:
        def __init__(self, index: int):
            self.index = index
    

    class _Edge:
        def __init__(self, vertices, cost):
            self.vertices = vertices
            self.cost = cost


        def get_other_vertex(self, vertex_index):
            if vertex_index == self.vertices[0]:
                return self.vertices[1]
            elif vertex_index == self.vertices[1]:
                return self.vertices[0]
            else:
                print("Input vertex is not part of the edge")
                return -1


    def __init__(self):
        self.vertices = {}
        self.adjacency_list = {}


    def add_vertex(self, index: int):
        if index not in self.vertices:
            self.vertices[index] = self._Vertex(index)
            self.adjacency_list[index] = {}
        else:
            print(f"Index {index} is already taken. Use a different index!")

    
    def add_edge(self, vertex_index1, vertex_index2, cost=1):
        if vertex_index1 not in self.vertices:
            print(f"Vertex with index {vertex_index1} is not present in the graph! Edge could not be created!")
            return
        if vertex_index2 not in self.vertices:
            print(f"Vertex with index {vertex_index2} is not present in the graph! Edge could not be created!")
            return
        if cost <= 0:
            print(f"Cost must be a positive number, not zero or a negative number! Edge was not created!")
            return
        if vertex_index2 in self.adjacency_list[vertex_index1]:
            print(f"Edge between the vertices already exists! Multigraph is not supported!")
            return
        new_edge = self._Edge((vertex_index1, vertex_index2), cost)
        self.adjacency_list[vertex_index1][vertex_index2] = new_edge
        self.adjacency_list[vertex_index2][vertex_index1] = new_edge
        

    def set_edge_cost(self, vertex_index1, vertex_index2, new_cost, insert=False):
        if new_cost <= 0:
            print(f"Cost must be a positive number, not zero or a negative number! Edge was not created!")
            return
        if vertex_index2 in self.adjacency_list[vertex_index1]:
            self.adjacency_list[vertex_index1][vertex_index2].cost = new_cost
            #self.adjacency_list[vertex_index2][vertex_index1] = new_cost
        else:
            if not insert:
                print("Such edge is not present in the graph. To create an edge if it doesn't exist, set parameter insert=True")
            else:
                self.add_edge(vertex_index1, vertex_index2, new_cost)


    def edge_in_graph(self, vertex_index1, vertex_index2):
        return vertex_index1 in self.adjacency_list and vertex_index2 in self.adjacency_list[vertex_index1]

        
    def get_edge(self, vertex_index1, vertex_index2) -> _Edge:
        return self.adjacency_list[vertex_index1][vertex_index2]


    def get_vertex_edges(self, vertex_index) -> List[_Edge]:
        return self.adjacency_list[vertex_index]


    def get_vertex_indices(self):
        return list(self.vertices.keys())



class Pathfinder:
    class _Path:
        def __init__(self):
            self.path = []
            self.path_cost = 0

        def add_to_path(self, vertex_index, edge_cost):
            self.path.append(vertex_index)
            self.path_cost += edge_cost

        def reverse(self):
            self.path.reverse()


    def __init__(self):
        self.graph = Graph()


    def clear_graph(self):
        self.graph = Graph()


    def edge_in_graph(self, vertex_index1, vertex_index2):
        return self.graph.edge_in_graph(vertex_index1, vertex_index2)

    
    def add_vertex(self, index):
        self.graph.add_vertex(index)


    def add_edge(self, vertex_index1, vertex_index2, cost=1):
        self.graph.add_edge(vertex_index1, vertex_index2, cost)

    
    def get_graph(self) -> Graph:
        return self.graph


    def find_path(self, start, goal) -> _Path:
        dists = {}
        parents = {}
        visited = {}
        vertices = self.graph.get_vertex_indices()
        for vertex in vertices:
            dists[vertex] = float("inf")
            parents[vertex] = None
            visited[vertex] = False
        priority_queue = PriorityQueue()
        dists[start] = 0
        priority_queue.put((dists[start], start))
        while not priority_queue.empty():
            current_dist, vertex_index = priority_queue.get()
            if vertex_index == goal:
                break
            if visited[vertex_index]:
                continue
            visited[vertex_index] = True
            for neighbour_index in self.graph.get_vertex_edges(vertex_index):
                if not visited[neighbour_index]:
                    edge_cost = self.graph.get_edge(vertex_index, neighbour_index).cost
                    if current_dist + edge_cost < dists[neighbour_index]:
                        dists[neighbour_index] = current_dist + edge_cost
                        parents[neighbour_index] = vertex_index
                        priority_queue.put((dists[neighbour_index], neighbour_index))
        path = self._Path()
        current_index = goal
        while parents[current_index] != None:
            prev_index = parents[current_index]
            edge_cost = self.graph.get_edge(prev_index, current_index).cost
            path.add_to_path(current_index, edge_cost)
            current_index = prev_index
        path.reverse()
        return path
