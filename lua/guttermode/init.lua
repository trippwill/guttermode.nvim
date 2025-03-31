---@diagnostic disable: undefined-global

-- guttermode.nvim - Display Neovim mode using a gutter sign
local M = {}

function M.setup(opts)
  opts = vim.tbl_deep_extend("force", {
    follow_cursor = false,
    sign_char = "│",
    debounce_ms = 20,
    debug = false, -- set to true to enable development logs
  }, opts or {})

  local api = vim.api
  local fn = vim.fn
  local timer = nil

  local function log(msg)
    if opts.debug then
      vim.schedule(function()
        vim.notify("[guttermode] " .. msg, vim.log.levels.INFO)
      end)
    end
  end

  fn.sign_define("GutterModeSign", {
    text = opts.sign_char,
    texthl = "GutterModeHL",
    linehl = "",
    numhl = "",
  })

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

  local function update_sign_color()
    local mode = fn.mode()
    local lualine_mode = mode_to_lualine[mode] or "normal"
    local lualine_group = "lualine_a_" .. lualine_mode

    local ok, hl = pcall(api.nvim_get_hl, 0, { name = lualine_group, link = false })
    if not ok or not hl or not hl.bg then
      return
    end

    local bg = api.nvim_get_hl(0, { name = "Normal" }).bg or "NONE"
    api.nvim_set_hl(0, "GutterModeHL", {
      fg = hl.bg,
      bg = bg,
    })
  end

  local function place_signs()
    for _, win in ipairs(api.nvim_list_wins()) do
      if api.nvim_win_is_valid(win) and vim.fn.win_gettype(win) == "" then
        local ok, screenpos = pcall(vim.fn.win_screenpos, win)
        if not ok then
          log("win_screenpos failed for win " .. win)
        end
        if ok and screenpos and screenpos[1] > 0 then
          local buf = api.nvim_win_get_buf(win)
          if api.nvim_buf_is_valid(buf) and vim.bo[buf].buftype == "" then
            fn.sign_unplace("GutterModeGroup", { buffer = buf })
            log("unplaced signs in buffer " .. buf)

            if opts.follow_cursor then
              local ok_cursor, cursor = pcall(api.nvim_win_get_cursor, win)
              if not ok_cursor then
                log("nvim_win_get_cursor failed for win " .. win)
              end
              if ok_cursor and cursor then
                local cursor_line = cursor[1]
                fn.sign_place(0, "GutterModeGroup", "GutterModeSign", buf, {
                  lnum = cursor_line,
                  priority = 10,
                })
                log("placed sign on line " .. cursor_line .. " in buffer " .. buf)
              end
            else
              local ok_lines, line_count = pcall(api.nvim_buf_line_count, buf)
              if not ok_lines then
                log("nvim_buf_line_count failed for buffer " .. buf)
              end
              if ok_lines then
                for lnum = 1, line_count do
                  fn.sign_place(0, "GutterModeGroup", "GutterModeSign", buf, {
                    lnum = lnum,
                    priority = 10,
                  })
                end
                log("placed signs on all " .. line_count .. " lines in buffer " .. buf)
              end
            end
          end
        end
      end
    end
  end

  local function schedule_update()
    if timer and not timer:is_closing() then
      timer:stop()
      timer:close()
    end
    timer = vim.defer_fn(function()
      local ok, err = pcall(function()
        update_sign_color()
        place_signs()
      end)
      if not ok then
        log("Error during deferred update: " .. tostring(err))
      end
    end, opts.debounce_ms)
  end

  api.nvim_create_autocmd({
    "ModeChanged",
    "WinEnter",
    "BufWinEnter",
    "CursorMoved",
    "CursorMovedI",
    "InsertEnter",
    "InsertLeave",
  }, {
    callback = schedule_update,
  })
end

return M
