# guttermode.nvim

🚦 A minimal Neovim plugin that displays your current mode using a colored sign in the gutter (sign column), with colors that match your `lualine` theme.

---

## ✨ Features

- ✅ Seamless integration with your existing colorscheme via `lualine_a_{mode}` highlight groups
- ✅ Updates in all modes (Normal, Insert, Visual, Replace, Command)
- ✅ Optional cursor-following or full-height border
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
    follow_cursor = false, -- true = only current line, false = all lines
    sign_char = "│",        -- customize gutter character
    debounce_ms = 20,       -- debounce updates (ms)
    debug = false,          -- enable logging
  },
  config = function(_, opts)
    require("guttermode").setup(opts)
  end,
}
```

---

## ⚙️ Options

| Name           | Type    | Default | Description                                                                 |
|----------------|---------|---------|-----------------------------------------------------------------------------|
| `follow_cursor`| boolean | `false` | Show sign only on the cursor line (`true`) or on all lines (`false`)       |
| `sign_char`    | string  | `"│"`    | The character to show in the sign column                                   |
| `debounce_ms`  | number  | `20`     | Debounce interval for updates (in milliseconds)                            |
| `debug`        | boolean | `false` | Enable logging for development/debugging                                   |

---

## 🧪 Planned Features

- [ ] Optionally disable in inactive windows
- [ ] Support for per-window or per-tab highlight overrides
- [ ] Compatibility layer for users without `lualine`

---

## 🪪 License

MIT © [trippwill](https://github.com/trippwill)

---

## 🙏 Thanks

This plugin was inspired by a desire for a subtle but visible indicator of insert/visual mode in terminal Neovim, without disrupting your layout.
