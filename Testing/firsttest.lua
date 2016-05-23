function closure()
  local a = 1
  return function ()
    a = a + 1
    print(a)
  end
end

local derp = closure()
derp()
derp()

