local M = {
  "Pocco81/auto-save.nvim",
  event = "VeryLazy",
}

function M.config()
  require("auto-save").setup {
    trigger_events = { "InsertLeave", "TextChanged" }, -- vim events that trigger auto-save. See :h events
    -- function that determines whether to save the current buffer or not
    -- return true: if buffer is ok to be saved
    -- return false: if it's not ok to be saved
    condition = function(buf)
      local fn = vim.fn
      local utils = require "auto-save.utils.data"
      local ft = fn.getbufvar(buf, "&filetype")
      if ft == "harpoon" or ft:find "Neogit" or ft:find "Dressing" or ft:find "Diffview" then
        return false
      end

      if fn.getbufvar(buf, "&modifiable") == 1 and utils.not_in(fn.getbufvar(buf, "&filetype"), {}) then
        return true -- met condition(s), can save
      end
      return false -- can't save
    end,
  }
end

return M
