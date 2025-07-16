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
    opts = { open_cmd = "qutebrowser %s", follow_cursor = true },
  },
  {
    "morhetz/gruvbox",
    lazy = false, -- load immediately so colorscheme is available
  },
})

vim.opt.termguicolors = true
vim.cmd("colorscheme gruvbox")

-- Your LSP config and keymaps below unchanged
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

vim.keymap.set("i", "<C-CR>", "<Esc>:OpenPdf<CR>a", { noremap = true, silent = true })

vim.keymap.set("i", "<C-p>", function()
  vim.cmd("stopinsert")
  pcall(vim.cmd, "TypstPreview")
  vim.cmd("TypstPreviewFollowCursor")
  vim.cmd("startinsert")
end, { noremap = true, silent = true })
