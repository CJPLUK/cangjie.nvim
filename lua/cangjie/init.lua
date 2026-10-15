local M = {}

---Register the parser with either the main or legacy master nvim-treesitter API.
---@return boolean registered
function M.register_parser()
  local ok, parsers = pcall(require, "nvim-treesitter.parsers")
  if not ok then
    return false
  end

  local config = {
    install_info = {
      -- GitHub mirror of https://gitcode.com/Cangjie-SIG/tree-sitter-cangjie.
      -- Keep the revision in sync with the grammar used by our queries.
      url = "https://github.com/cangjielanguage-sig/tree-sitter-cangjie",
      revision = "b145ccdc9b64082bf9a558ab54e7b536d7a57d73",
      files = { "src/parser.c", "src/scanner.c" },
      generate = false,
      requires_generate_from_grammar = false,
      generate_requires_npm = false,
    },
    filetype = "cangjie",
  }

  if type(parsers.get_parser_configs) == "function" then
    parsers.get_parser_configs().cangjie = config
  else
    parsers.cangjie = config
  end
  return true
end

---Called automatically on startup; safe to call early before parser installation.
function M.setup()
  vim.filetype.add({ extension = { cj = "cangjie" } })
  vim.treesitter.language.register("cangjie", "cangjie")

  -- The main branch discards and reloads its parser table before installation.
  vim.api.nvim_create_autocmd("User", {
    group = vim.api.nvim_create_augroup("CangjieParser", { clear = true }),
    pattern = "TSUpdate",
    callback = function()
      M.register_parser()
    end,
    desc = "Register the Cangjie Tree-sitter parser",
  })
  M.register_parser()
end

return M
