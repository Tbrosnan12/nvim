require("lazy").setup({
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    opts = {
      ensure_installed = { "lua", "markdown", "typst" },
      highlight = { enable = true },
    },
  },
  { "neovim/nvim-lspconfig" },

  -- Autocompletion setup
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<Tab>"] = cmp.mapping.select_next_item(),
          ["<S-Tab>"] = cmp.mapping.select_prev_item(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
        }),
        sources = {
          { name = "nvim_lsp" },
          { name = "luasnip" },
        },
      })
    end,
  },

  {
    "chomosuke/typst-preview.nvim",
    ft = "typst",
    version = "1.*",
    opts = { open_cmd = "qutebrowser %s", follow_cursor = true },
  },

  {
    "morhetz/gruvbox",
    lazy = false,
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

-- keybind for lsp hover
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local bufnr = args.buf
    local opts = { buffer = bufnr }
    vim.keymap.set("i", "<C-i>", function()
      -- Use <C-o>K trick to run hover without leaving insert mode
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-o>K", true, false, true), "n", false)
    end, opts)
  end,
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
