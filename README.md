# cangjie.nvim

Tree-sitter syntax highlighting for [Cangjie](https://cangjie-lang.cn/) in Neovim,
adapted from [CJPLUK/zed-cangjie](https://github.com/CJPLUK/zed-cangjie).

- Detects `*.cj` as `cangjie` and automatically starts Tree-sitter highlighting.
- Highlights declarations, calls, types, macros, comments, literals, and string interpolation.
- Sets `//` / `/* */` comment support and four-space, space-based indentation defaults.
- Registers the parser with both current (`main`) and legacy (`master`) `nvim-treesitter`.

## Requirements

- Neovim **0.11+**. Current `nvim-treesitter` `main` requires **0.12+**;
  use its `master` branch with Neovim 0.11.
- [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) to install
  the parser, plus that branch's build prerequisites (a C compiler, `curl`, `tar`,
  and, for `main`, Tree-sitter CLI 0.26.1+).

Highlighting itself uses Neovim's built-in Tree-sitter support. A Cangjie SDK is
not required.

## Install

### vim.pack (Neovim 0.12+)

Add this to your `init.lua`, after any existing `nvim-treesitter` configuration:

```lua
vim.pack.add({
  { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
  { src = "https://github.com/CJPLUK/cangjie.nvim" },
})

-- Register the parser before installing: plugin/ files load after init.lua.
require("cangjie").setup()
require("nvim-treesitter").install({ "cangjie" }):wait(300000)
```

Restart Neovim and open a `.cj` file. The final line installs the parser if
needed and waits up to five minutes, so highlighting is ready for the first
buffer. Subsequent launches skip installation when the parser is already present.

### lazy.nvim

Add this to your plugin specifications:

```lua
{
  "CJPLUK/cangjie.nvim",
  lazy = false,
  dependencies = {
    {
      "nvim-treesitter/nvim-treesitter",
      branch = "main", -- use "master" with Neovim 0.11
      lazy = false,
      build = ":TSUpdate",
    },
  },
}
```

Restart Neovim, then run:

```vim
:TSInstall cangjie
```

Wait for installation to finish and open (or reopen) a `.cj` file. Highlighting
starts automatically. `cjpm.toml` uses Neovim's normal TOML support.

### Other plugin managers / native packages

Install [`CJPLUK/cangjie.nvim`](https://github.com/CJPLUK/cangjie.nvim) with your
plugin manager, or clone it into
`stdpath('data')/site/pack/plugins/start/cangjie.nvim`. Load `nvim-treesitter`
at startup as well, then run `:TSInstall cangjie`.

If installing parsers from your configuration before startup plugins are sourced,
register Cangjie first:

```lua
require("cangjie").setup()
require("nvim-treesitter").install({ "cangjie" }) -- main branch
```

With legacy `master`, call `require("cangjie").setup()` before your
`require("nvim-treesitter.configs").setup(...)` if you put `cangjie` in
`ensure_installed`. Both plugins must already be on `runtimepath` at that point.

## Customization and troubleshooting

Use your colorscheme's standard Tree-sitter highlight groups; inspect any token
with `:Inspect` or the syntax tree with `:InspectTree`.

Override buffer defaults in `after/ftplugin/cangjie.lua`, for example:

```lua
vim.bo.shiftwidth = 2
vim.bo.softtabstop = 2
```

If highlighting does not start, check `:set filetype?` (it should say `cangjie`),
run `:TSInstall cangjie`, and reopen the buffer. `:checkhealth nvim-treesitter`
helps diagnose parser build problems. After changing parser versions, restart
Neovim so it loads the new shared library.

## Upstream sources

- Queries: [`CJPLUK/zed-cangjie` at `36e5f3c`](https://github.com/CJPLUK/zed-cangjie/tree/36e5f3c97e2ecf3cabfffc5baca974ce3f00b436/languages/cangjie),
  ported to Neovim capture names and extended for booleans, runes, built-in types,
  and additional keywords.
- Parser: [`Cangjie-SIG/tree-sitter-cangjie`](https://gitcode.com/Cangjie-SIG/tree-sitter-cangjie),
  pinned to **`b145ccdc9b64082bf9a558ab54e7b536d7a57d73`**, the revision used by Zed.
  Installation uses the [Cangjie SIG GitHub mirror](https://github.com/cangjielanguage-sig/tree-sitter-cangjie)
  at the identical commit because current `nvim-treesitter` uses GitHub-style
  archive URLs. Both the generated parser and its external C scanner are built.

## Development check

With the pinned parser already compiled, run the headless smoke test from this
directory:

```sh
CANGJIE_PARSER_PATH=/absolute/path/to/parser/cangjie.so \
  nvim --headless -u NONE -l tests/smoke.lua
```

This checks real parser/query compatibility, representative highlight captures,
filetype detection, automatic highlighting, and buffer-local settings.

## License

MIT; see [LICENSE](LICENSE), including attribution for the upstream queries.
