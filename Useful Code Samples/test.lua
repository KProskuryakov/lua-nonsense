p = {1, 2, 3, 4, x = 6}
p[3] = nil
for k, v in ipairs(p) do
  print(k, v)
end
