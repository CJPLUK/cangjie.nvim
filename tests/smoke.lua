local root = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":p:h:h")
vim.opt.runtimepath:prepend(root)

local parser_path = assert(vim.env.CANGJIE_PARSER_PATH, "Set CANGJIE_PARSER_PATH to the compiled cangjie.so")
vim.treesitter.language.add("cangjie", { path = parser_path })
vim.cmd("runtime plugin/cangjie.lua")
vim.cmd("filetype plugin on")

assert(vim.filetype.match({ filename = "example.cj" }) == "cangjie", "Missing .cj filetype detection")
assert(vim.filetype.match({ filename = "cjpm.toml" }) == "toml", "CJPM manifests should use TOML")

vim.cmd.edit(vim.fn.fnameescape(root .. "/tests/fixtures/highlights.cj"))
local bufnr = vim.api.nvim_get_current_buf()
assert(vim.bo.filetype == "cangjie")
assert(vim.bo.commentstring == "// %s")
assert(vim.bo.comments:find("s1:/*", 1, true))
assert(vim.bo.expandtab and vim.bo.shiftwidth == 4 and vim.bo.softtabstop == 4 and vim.bo.tabstop == 4)
assert(vim.treesitter.highlighter.active[bufnr], "Highlighting did not start automatically")

local parser = vim.treesitter.get_parser(bufnr, "cangjie")
local tree = parser:parse()[1]
assert(not tree:root():has_error(), "The example should parse without ERROR or MISSING nodes")
local query = assert(vim.treesitter.query.get("cangjie", "highlights"))

-- Validate captures against the real grammar, including distinctions that a
-- query can silently miss even when it compiles successfully.
local captures = {}
for id, node in query:iter_captures(tree:root(), bufnr) do
  local name = query.captures[id]
  local text = vim.treesitter.get_node_text(node, bufnr)
  captures[name] = captures[name] or {}
  captures[name][text] = true
end

local expected = {
  ["module"] = { "showcase", "std.collection" },
  ["keyword.import"] = { "package", "import" },
  ["keyword.type"] = { "class", "interface", "struct", "enum", "type" },
  ["keyword.function"] = { "func", "get", "set" },
  ["keyword.modifier"] = { "private", "public" },
  ["keyword.return"] = { "return" },
  ["keyword.conditional"] = { "if", "else", "match", "case" },
  ["keyword.repeat"] = { "for", "in", "while", "do" },
  ["type"] = { "Greeter", "Named", "Point", "Color", "Count", "T" },
  ["type.builtin"] = { "Int64", "Bool", "Float64", "String" },
  ["constructor"] = { "init" },
  ["function"] = { "identity", "main" },
  ["function.call"] = { "identity", "println" },
  ["function.method.call"] = { "name" },
  ["function.macro"] = { "Assert" },
  ["variable.parameter"] = { "value", "greeting" },
  ["variable.member"] = { "greeting", "message", "x" },
  ["variable.builtin"] = { "this" },
  ["constant"] = { "MAX_COUNT", "Red", "Green", "Blue" },
  ["boolean"] = { "true", "false" },
  ["number"] = { "42" },
  ["number.float"] = { "3.14" },
  ["character"] = { "r'a'", "b'a'" },
  ["string"] = { '"Hello"', '#"raw text"#', '"Value: ${result + 1}"', '"""\nValue: ${result}\n"""' },
  ["none"] = { "${result + 1}" },
  ["punctuation.special"] = { "${", "}" },
  ["punctuation.bracket"] = { "(", ")", "{", "}", "<", ">" },
  ["punctuation.delimiter"] = { ":", "." },
  ["operator"] = { "+", "=", "+=", "<", "..", "--" },
  ["comment"] = { "// Syntax highlighting example.", "/* A block comment. */" },
}

local count = 0
local missing = {}
for name, texts in pairs(expected) do
  for _, text in ipairs(texts) do
    if not (captures[name] and captures[name][text]) then
      missing[#missing + 1] = ("Missing @%s for %q"):format(name, text)
    end
    count = count + 1
  end
end
assert(#missing == 0, table.concat(missing, "\n"))

-- The ftplugin must release its settings and highlighter when changing filetype.
vim.bo.filetype = "text"
assert(not vim.treesitter.highlighter.active[bufnr], "Cangjie highlighter survived a filetype change")
assert(vim.bo.shiftwidth == vim.go.shiftwidth and vim.bo.commentstring == vim.go.commentstring)

print(("nvim-cangjie: %d highlight assertions and buffer smoke checks passed"):format(count))
vim.cmd("qa!")
