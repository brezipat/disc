class Grid:
    def __init__(self, height, width):
        self.height = height
        self.width = width
        self.grid = ["Empty"] * width * height
    
    
    def cell_1d_index(self, x, y):
        return y + x * self.width


    def index_to_cell(self, index):
        x = int(index/self.width)
        y = index % self.width
        return x, y


    def out_of_bounds(self, x, y):
        return x < 0 or x >= self.height or y < 0 or y >= self.width


    def get_cell(self, x, y):
        return self.grid[self.cell_1d_index(x, y)]