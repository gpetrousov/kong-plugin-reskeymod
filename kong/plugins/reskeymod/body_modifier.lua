local cjson = require "cjson.safe"


local find = string.find
local type = type
local sub = string.sub
local gsub = string.gsub
local match = string.match
local lower = string.lower

local noop = function() end


local _M = {}

-- Renames a single key name from the body withou changing it's value
local function rename_body_key(body, old_key_name, new_key_name)
  if body then
		local key_value = body[old_key_name]
		body[old_key_name] = nil
		body[new_key_name] = key_value
	  return body
	else
    print("No body, or body is encrypted")
    print("Set accept-encoding to 0")
		return
  end
end

-- String to array decoder
local function read_json_body(body)
  if body then
    return cjson.decode(body)
  end
end


local function iter(config_array)
  if type(config_array) ~= "table" then
    return noop
  end

  return function(config_array, i)
    i = i + 1

    local current_pair = config_array[i]
    if current_pair == nil then -- n + 1
      return nil
    end

    local current_name, current_value = match(current_pair, "^([^:]+):*(.-)$")
    if current_value == "" then
      current_value = nil
    end

    return i, current_name, current_value
  end, config_array, 0
end


function _M.modify_json_body(conf, buffered_data)
  local json_body = read_json_body(buffered_data)

  if json_body == nil then
    print("JSON body is nil")
    return
  end

  -- print("The body is: ", json_body)
	-- rename JSON keys from body
  for _, name, value in iter(conf.rename_body_key.json) do
    local v = cjson.encode(value)
    if v and sub(v, 1, 1) == [["]] and sub(v, -1, -1) == [["]] then
      v = gsub(sub(v, 2, -2), [[\"]], [["]]) -- To prevent having double encoded quotes
    end
    v = v and gsub(v, [[\/]], [[/]]) -- To prevent having double encoded slashes
		rename_body_key(json_body, name, v)
  end

  print("Returning body")

  return cjson.encode(json_body)
end

return _M
