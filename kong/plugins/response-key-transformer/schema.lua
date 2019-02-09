local colon_string_array = {
  type = "array",
  default = {},
  elements = { type = "string", match = "^[^:]+:.*$" },
}

local colon_string_record = {
  type = "record",
  fields = {
    { json = colon_string_array },
  },
}

return {
  name = "response-key-transformer",
  fields = {
    { config = {
        type = "record",
        fields = {
          { rename_body_key = colon_string_record },
        },
      },
    },
  },
}

-- Accessing the fields from handler
-- config.rename_body_key.json
