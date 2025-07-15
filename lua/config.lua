-- bootstrap lazy.nvim
require("lazy").setup({
  {
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
    opts = {
      ensure_installed = { "lua", "markdown", "typst" },
      highlight = { enable = true },
    },
  },
  {
    "neovim/nvim-lspconfig",
  },
  {
    "chomosuke/typst-preview.nvim",
    ft = "typst",
    version = "1.*",
    opts = {open_cmd = "qutebrowser %s",follow_cursor = true,},
  },
  -- add other plugins here as needed
})

local lspconfig = require("lspconfig")
local util = require("lspconfig.util")

lspconfig.tinymist.setup({
  root_dir = util.root_pattern("typst.toml", ".git", "."),
  settings = {
    formatterMode = "typstyle",
    exportPdf = "onType",
    semanticTokens = "disable",
  },
})

vim.api.nvim_create_user_command("OpenPdf", function()
  local filepath = vim.api.nvim_buf_get_name(0)
  if filepath:match("%.typ$") then
    local pdf_path = filepath:gsub("%.typ$", ".pdf")
    vim.system({ "sioyek", "--reuse-window", pdf_path })
  end
end, {})

-- keybind for OpenPdf
vim.keymap.set("i", "<C-CR>", "<Esc>:OpenPdf<CR>a", { noremap = true, silent = true })


--keybind for preview

vim.keymap.set("i", "<C-p>", function()
  vim.cmd("stopinsert")
  pcall(vim.cmd, "TypstPreview")
  vim.cmd("TypstPreviewFollowCursor")
  vim.cmd("startinsert")
end, { noremap = true, silent = true })
