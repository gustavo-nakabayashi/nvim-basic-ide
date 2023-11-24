local M = {
  "jose-elias-alvarez/null-ls.nvim",
}

function M.config()
  local null_ls = require "null-ls"

  local formatting = null_ls.builtins.formatting

  null_ls.setup {
    sources = {
      formatting.stylua,
      formatting.prettier,
      formatting.prettier.with {
        extra_filetypes = { "toml", "liquid" },
      },
      formatting.black.with { extra_args = { "--fast" } },
      formatting.stylua,
      formatting.google_java_format,
      diagnostics.flake8,
      diagnostics.eslint
    },
  }
end

return M
