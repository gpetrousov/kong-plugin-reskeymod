local BasePlugin = require "kong.plugins.base_plugin"
local body_modifier = require "kong.plugins.reskeymod.body_modifier"

local concat = table.concat
local lower = string.lower
local find = string.find
local kong = kong
local ngx = ngx

-- Check if rename_body_key is enabled
-- Return True or False
local function is_body_transform_set(conf)
  return #conf.rename_body_key.json  > 0
end

-- Check if content_type is application/json
-- Return True of False
local function is_json_body(content_type)
  return content_type and find(lower(content_type), "application/json", nil, true)
end

local ResKeyModHandler = BasePlugin:extend()

function ResKeyModHandler:new()
  ResKeyModHandler.super.new(self, "reskeymod")
end


function ResKeyModHandler:body_filter(conf)
  ResKeyModHandler.super.body_filter(self)

  if is_body_transform_set(conf) and is_json_body(kong.response.get_header("Content-Type")) then
    print("HHHHHHHEEEEEEEEEEEEELLLLLLLLLLLLOOOOOOOOOOOOOOOOOOO!!!!!!!!!!!!!")
    local ctx = ngx.ctx
    local chunk, eof = ngx.arg[1], ngx.arg[2]

    ctx.rt_body_chunks = ctx.rt_body_chunks or {}
    ctx.rt_body_chunk_number = ctx.rt_body_chunk_number or 1

    if eof then
      print("calling body modifier now")
      local chunks = concat(ctx.rt_body_chunks)
      local body = body_modifier.modify_json_body(conf, chunks)
      ngx.arg[1] = body or chunks

    else
      ctx.rt_body_chunks[ctx.rt_body_chunk_number] = chunk
      ctx.rt_body_chunk_number = ctx.rt_body_chunk_number + 1
      ngx.arg[1] = nil
    end
  end
end

ResKeyModHandler.PRIORITY = 800
ResKeyModHandler.VERSION = "1.0.0"

return ResKeyModHandler
