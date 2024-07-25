-- primeless random.lua
-- use 'openssl prime -generate -bits 81' 4 times to generate 4 primes
return function(primes)
  if not (primes[1] and primes[2] and primes[3] and primes[4]) then error('Must pass table of 4 primes to the primeless random function') end
  local jsf32 = function(a, b, c, d)
    return function(min, max)
      if min == nil then
        min = 0
      end
      if max == nil then
        max = 1
      end
      a = bit32.bor(a, 0)
      b = bit32.bor(b, 0)
      c = bit32.bor(c, 0)
      d = bit32.bor(d, 0)
      local t = bit32.bor(a - (bit32.bor(bit32.lshift(b, 27), bit32.rshift(b, 5))), 0)
      a = bit32.bxor(b, (bit32.bor(bit32.lshift(c, 17), bit32.rshift(c, 15))))
      b = bit32.bor(c + d, 0)
      c = bit32.bor(d + t, 0)
      d = bit32.bor(a + t, 0)
      if min > max then
        local storage = min
        min = max
        max = storage
      end
      return ((bit32.rshift(d, 0)) / 4294967296) * (max - min) + min
    end
  end

  local clock = os.clock
  local ourClock1 = clock()
  local ourClock1Split = (tonumber(string.split(tostring(ourClock1), '.')[2] or '1'))
  local ourTime = os.time() + ourClock1 % 1
  -- use some cpu time
  do
    local _rn = jsf32(1, 1, 1, 1)
    for _ = 0, 10, 1 do
      _rn(_, _ * 10)
    end
  end
  local ourClock2 = clock()
  local ourClock2Split = (tonumber(string.split(tostring(ourClock2), '.')[2] or '1') or ourClock2 * 10)
  local ourClock3 = clock() - (ourClock2 - ourClock1)
  local ourClock3Split = (tonumber(string.split(tostring(ourClock3), '.')[2] or '1'))
  local seedA = bit32.bxor(ourClock1, ourTime + ourClock3Split or ourClock2 * 10)
  local seedB = bit32.bxor(ourClock2Split, ourClock3)
  local seedC = bit32.bxor(bit32.bxor(bit32.bxor(ourClock1 * #tostring(ourClock1 % 1), primes[1]), ourClock3Split), primes[2])
  local seedD = bit32.bxor(bit32.bxor(bit32.bxor(ourClock2 * #tostring(ourClock3 % 1), primes[3]), ourClock1Split), primes[4])

  return jsf32(seedA, seedB, seedC, seedD) ---- FOR MIN,MAX CALLS: FLOOR THE RESULT OF THIS FUNCTION IF U WANT IT TO BE AN INT
end
