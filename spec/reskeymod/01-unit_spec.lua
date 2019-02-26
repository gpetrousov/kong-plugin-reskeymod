local body_modifier = require "kong.plugins.reskeymod.body_modifier"
local cjson = require "cjson"

describe("Plugin: reskeymod", function()
  describe("modify_json_body()", function()

    describe("rename body key", function()
      local conf = {
        rename_body_key      = {
					json = {"key1:key11"}
        },
      }
      it("rename single JSON body key", function()
        local json = [[{"key1" : "val11"}]]
        local body = body_modifier.modify_json_body(conf, json)
        local body_json = cjson.decode(body)
        assert.same({key11="val11"}, body_json)
      end)

      local conf = {
        rename_body_key      = {
					json = {"key1:key11","key2:key22","key3:key33"}
        },
      }
      it("rename multiple JSON body keys", function()
        local json = [[{"key1" : "val11", "key2" : "val22", "key3" : "val33"}]]
        local body = body_modifier.modify_json_body(conf, json)
        local body_json = cjson.decode(body)
        assert.same({key11 = "val11", key22 = "val22", key33 = "val33"}, body_json)
      end)

      it("don't rename keys if they are not present", function()
        local json = [[{"k1" : "v1", "k2" : "v2", "k3" : "v3"}]]
        local body = body_modifier.modify_json_body(conf, json)
        local body_json = cjson.decode(body)
        assert.same({k1 = "v1", k2 = "v2", k3 = "v3"}, body_json)
      end)
    end)
  end)
end)
