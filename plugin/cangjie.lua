if vim.g.loaded_cangjie then
  return
end
vim.g.loaded_cangjie = true

require("cangjie").setup()
