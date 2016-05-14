-- Kostyantyn Proskuryakov
-- Feb 16, 2016
-- Programming in Lua, 3rd ED, Chapter 11

-- Exercise 11.1
-- Modify the queue implementation so that both indices return to 0 when the queue is empty
List = {}

function List.new ()
  return {first = 0, last = -1}
end

function List.pushfirst (list, value)
  local first = list.first - 1
  list.first = first
  list[first] = value
end

function List.pushlast (list, value)
  local last = list.last + 1
  list.last = last
  list[last] = value
end

function List.popfirst (list)
  local first = list.first
  if first > list.last then error("List is empty") end
  local value = list[first]
  list[first] = nil
  list.first = first + 1
  if list.first > list.last then list.first = 0; list.last = -1 end
  return value
end

function List.poplast (list)
  local last = list.last
  if first > list.last then error("List is empty") end
  local value = list[last]
  list[last] = nil
  list.first = last - 1
  if list.first > list.last then list.first = 0; list.last = -1 end
  return value
end

local list = List.new()
List.pushfirst(list, 1)
List.pushlast(list, 2)
List.pushfirst(list, 3)
print(list.first, list.last)

print(List.popfirst(list))
print(List.popfirst(list))
print(List.popfirst(list))
print(list.first, list.last)


-- Exercise 11.3
-- Modify the graph structure so that it can keep a label for each arc. The structure should represent each arc by an object, too, with two fields: its label and the node it points to. Instead of an adjacent set, each node keeps an incident set that contains the arcs that originate at that node.
-- Adapt the readgraph function to read two node names plus a label from each line in the input file. (Assume that the label is a number.)
function name2node (graph, name)
  local node = graph[name]
  if not node then
    -- node does not exist; create a new one
    node = {name = name, inc = {}}
    graph[name] = node
  end
  return node
end

function readgraph ()
  local graph = {}
  for line in io.lines("PiL_3rd_Exercises\\ex11_3graphs.txt", "*L") do
    -- split line in two names and a label
    local namefrom, nameto, label = string.match(line, "(%S+)%s+(%S+)%s+(%d+)")
    -- find corresponding nodes
    local from = name2node(graph, namefrom)
    local to = name2node(graph, nameto)
    -- adds 'to' to the adjacent set of 'from'
    from.inc[to] = label
  end
  return graph
end

function findpath (curr, to, path, visited)
  path = path or {}
  visited = visited or {}
  if visited[curr] then         -- node already visited?
    return nil                  -- no path here
  end
  visited[curr] = true          -- mark this node as visited
  path[#path + 1] = curr        -- add it to path
  if curr == to then            -- final node?
    return path
  end
  -- try all adjacent nodes
  for node in pairs(curr.inc) do
    local p = findpath(node, to, path, visited)
    if p then return p end
  end
  path[#path] = nil     -- remove node from path
end

function printpath (path)
  for i = 1, #path do
    print(path[i].name)
  end
end

g = readgraph()
a = name2node(g, "a")
b = name2node(g, "b")
p = findpath(a, b)
--if p then printpath(p) end

-- Exercise 11.4
-- Write a function to find the shortest path between two given nodes. (Hint: use Dijkstra's algorithm.)
function findshortestpath (begin, to)
  local used = {}
  local prev = {}
  local current = {[begin] = 0}
  
  while next(current) ~= nil do
    for curnode, distance in pairs(current) do
      for node, label in pairs(curnode.inc) do
        
        if used[node] == nil then
          local alt = distance + label
          if current[node] == nil or alt < current[node] then
            current[node] = alt
            prev[node] = curnode
          end
        end
        
      end
      used[curnode], current[curnode] = current[curnode], nil
    end
  end
  local path = {}
  local cur = to
  local i = 1
  while cur ~= nil do
    path[i] = cur
    i = i + 1
    cur = prev[cur]
  end
  return path
end

function printshortestpath (path)
  for i = #path, 1, -1 do
    print(path[i].name)
  end
end

printshortestpath(findshortestpath(a, b))
