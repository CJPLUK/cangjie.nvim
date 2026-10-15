if vim.b.did_ftplugin then
  return
end
vim.b.did_ftplugin = true

vim.bo.commentstring = "// %s"
vim.bo.comments = "s1:/*,mb:*,ex:*/,://"
vim.bo.expandtab = true
vim.bo.shiftwidth = 4
vim.bo.softtabstop = 4
vim.bo.tabstop = 4

vim.b.undo_ftplugin = "setlocal commentstring< comments< expandtab< shiftwidth< softtabstop< tabstop<"
  .. " | lua vim.treesitter.stop()"

local ok, err = pcall(vim.treesitter.start, 0, "cangjie")
if not ok then
  vim.notify_once(
    "nvim-cangjie: could not start Tree-sitter highlighting. "
      .. "Install the parser with :TSInstall cangjie, then reopen the buffer.\n"
      .. tostring(err),
    vim.log.levels.WARN
  )
end
