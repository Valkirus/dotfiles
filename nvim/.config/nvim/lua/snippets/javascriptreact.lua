-- Reuse all the same snippets for .jsx files
-- Simply require the tsx snippets file
local ls = require("luasnip")
ls.add_snippets("javascriptreact", require("snippets.typescriptreact"), { key = "jsx-shared" })
return {}
