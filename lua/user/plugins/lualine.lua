local M = {
  "nvim-lualine/lualine.nvim",
}

function M.config()
  local sl_hl = vim.api.nvim_get_hl_by_name("StatusLine", true)
  vim.api.nvim_set_hl(0, "Copilot", { fg = "#6CC644", bg = sl_hl.background })
  local icons = require "user.icons"
  local diff = {
    "diff",
    colored = true,
    symbols = { added = icons.git.LineAdded, modified = icons.git.LineModified, removed = icons.git.LineRemoved }, -- Changes the symbols used by the diff.
  }

  local copilot = function()
    local buf_clients = vim.lsp.get_active_clients { bufnr = 0 }
    if #buf_clients == 0 then
      return "LSP Inactive"
    end

    local buf_client_names = {}
    local copilot_active = false

    for _, client in pairs(buf_clients) do
      if client.name ~= "null-ls" and client.name ~= "copilot" then
        table.insert(buf_client_names, client.name)
      end

      if client.name == "copilot" then
        copilot_active = true
      end
    end

    if copilot_active then
      return "%#Copilot#" .. icons.git.Octoface .. "%*"
    end
    return ""
  end

  local function basename(str)
    return string.gsub(str, "(.*/)(.*)", "%2")
  end

  local function lualine_harpoon()
    local harpoon = require("harpoon")
    local keys = { "1", "2", "3", "4" }
    local currentfile = basename(vim.fn.expand("%:p"))

    local s = ""

    for i, v in ipairs(harpoon:list().items) do
      local fn = basename(v.value)
      local prefix = fn ~= currentfile and keys[i] or "󰛢"

      s = s .. prefix .. " " .. fn
      if i < #harpoon:list().items then
        s = s .. " | "
      end
    end

    if #harpoon:list().items == 0 then
      s = s .. "󰛢"
    end

    return s
  end

  require("lualine").setup {
    options = {
      -- component_separators = { left = "", right = "" },
      -- section_separators = { left = "", right = "" },
      component_separators = { left = "", right = "" },
      section_separators = { left = "", right = "" },

      ignore_focus = { "NvimTree" },
    },
    tabline = {
      lualine_a = { lualine_harpoon },
      lualine_b = {},
      lualine_c = {},
      lualine_x = {},
      lualine_y = {},
      lualine_z = {},
    },
    sections = {
      -- lualine_a = { {"branch", icon =""} },
      -- lualine_b = { diff },
      -- lualine_c = { "diagnostics" },
      -- lualine_x = { copilot },
      -- lualine_y = { "filetype" },
      -- lualine_z = { "progress" },
      lualine_a = { "mode" },
      lualine_b = { "branch", "filename" },
      lualine_c = { diff },
      lualine_x = { "diagnostics", copilot },
      lualine_y = { "filetype" },
      lualine_z = { "progress" },
    },
    extensions = { "quickfix", "man", "fugitive" },
  }
end

return M
