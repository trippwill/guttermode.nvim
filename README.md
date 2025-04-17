# guttermode.nvim

🚦 A minimal Neovim plugin that displays your current mode using a colored sign
in the gutter (sign column), with colors that match your `lualine` theme.

---

## ✨ Features

- ✅ Seamless integration with your existing colorscheme via `lualine_a_{mode}` highlight groups
- ✅ Updates in all modes (Normal, Insert, Visual, Replace, Command)
- ✅ Fully theme-aware
- ✅ Lightweight, no dependencies

---

## 📦 Installation

### Using [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
  "trippwill/guttermode.nvim",
  event = "VeryLazy",
  opts = {
    symbol = "│",        -- customize gutter character
    debug = false,          -- enable logging
  },
  config = function(_, opts)
    require("guttermode").setup(opts)
  end,
}
```

### In your options.lua

This example shows integration with [snacks.nvim statuscolumn](https://github.com/folke/snacks.nvim/blob/main/docs/statuscolumn.md)

```lua
vim.o.statuscolumn = [[%!v:lua.require'guttermode'.get() .. v:lua.require'snacks.statuscolumn'.get()]]
```

---

## ⚙️ Options

| Name           | Type    | Default | Description                            |
|----------------|---------|---------|----------------------------------------|
| `symbol`    | string  | `"│"`    | The character to show in the sign column     |
| `debug`        | boolean | `false` | Enable logging for development/debugging   |

---

## 🧪 Planned Features

- [ ] Compatibility layer for users without `lualine`

---

## 🪪 License

MIT © [trippwill](https://github.com/trippwill)

---

## 🙏 Thanks

This plugin was inspired by a desire for a subtle but visible indicator of
insert/visual mode in terminal Neovim, without disrupting your layout.
