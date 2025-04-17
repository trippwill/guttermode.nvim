---@diagnostic disable: undefined-global

-- guttermode.nvim - Display Neovim mode using a statuscolumn function
local M = {}

function M.setup(opts)
  opts = vim.tbl_deep_extend("force", {
    symbol = "│",
    debug = false, -- set to true to enable development logs
  }, opts or {})

  opts.symbol = tostring(opts.symbol or "X")

  local api = vim.api
  local fn = vim.fn
  local current_color = "NONE"

  local function log(msg)
    if opts.debug then
      vim.schedule(function()
        vim.notify("[guttermode] " .. msg, vim.log.levels.INFO)
      end)
    end
  end

  local mode_to_lualine = {
    n = "normal",
    no = "normal",
    ni = "normal",
    i = "insert",
    ic = "insert",
    v = "visual",
    V = "visual",
    ["\22"] = "visual",
    s = "visual",
    S = "visual",
    R = "replace",
    Rv = "replace",
    c = "command",
    t = "insert",
  }

  local function update_current_color()
    local mode = fn.mode()
    local lualine_mode = mode_to_lualine[mode] or "normal"
    local lualine_group = "lualine_a_" .. lualine_mode

    local ok, hl = pcall(api.nvim_get_hl, 0, { name = lualine_group, link = false })
    if not ok or not hl or not hl.bg then
      current_color = "NONE"
    else
      current_color = string.format("#%06x", hl.bg)
    end

    -- Update the highlight group for the gutter symbol
    api.nvim_set_hl(0, "GutterModeHL", { fg = current_color })
    log("Updated current color to " .. current_color)
  end

  local hlsymbol = "%#GutterModeHL#" .. opts.symbol

  function M.get()
    local winid = vim.g.statusline_winid
    local bufnr = api.nvim_win_get_buf(winid)

    -- Check if the window is a floating window
    local win_config = vim.api.nvim_win_get_config(winid)
    if win_config.relative ~= "" then
      return ""
    end

    if api.nvim_get_current_win() == winid and vim.bo[bufnr].buftype == "" then
      return hlsymbol
    end

    return ""
  end

  -- Set up an autocommand to update the color when the mode changes
  api.nvim_create_autocmd({
    "ModeChanged",
    "WinEnter",
    "BufWinEnter",
    "InsertEnter",
    "InsertLeave",
  }, {
    callback = function()
      update_current_color()
    end,
  })

  -- Initialize the highlight group
  update_current_color()
  log("guttermode.nvim setup complete")
end
return M
