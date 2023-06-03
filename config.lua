-- general
lvim.log.level = "warn"
lvim.format_on_save.enabled = true
lvim.colorscheme = "edge"
vim.opt.relativenumber = true
lvim.keys.normal_mode["<Space><Space>"] = ":NvimTreeToggle<CR>"


-- Key mappings
local key_mappings = {
  n = {
    { '<leader>V', ':split<CR>' },
    { '<leader>v', ':vsplit<CR>' },
    { '<leader>g', ':G<CR>' },
    { '<', ':bprev<CR>' },
    { '>', ':bnext<CR>' },
  },
}

for mode, mappings in pairs(key_mappings) do
  for _, map in pairs(mappings) do
    vim.api.nvim_set_keymap(mode, map[1], map[2], { noremap = true, silent = true })
  end
end


-- Plugin configuration
lvim.builtin.alpha.active = true
lvim.builtin.alpha.mode = "dashboard"
lvim.builtin.terminal.active = true
lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.nvimtree.setup.renderer.icons.show.git = false


-- Treesitter configuration
lvim.builtin.treesitter.ensure_installed = {
  "bash", "c", "javascript", "json", "lua", "python", "typescript", "tsx", "css", "rust", "java", "yaml",
}
lvim.builtin.treesitter.ignore_install = { "haskell" }
lvim.builtin.treesitter.highlight.enable = true


-- LSP settings
lvim.lsp.installer.setup.ensure_installed = { "svelte" }
local lsp_opts = {}
require("lvim.lsp.manager").setup("tailwindcss", lsp_opts)
require("lvim.lsp.manager").setup("eslint", lsp_opts)


-- Treesitter configuration
lvim.builtin.treesitter.ensure_installed = {
  "lua", "javascript", "typescript", "html", "css", "vue", "svelte",
}
lvim.builtin.treesitter.highlight.enable = true
lvim.builtin.treesitter.highlight.use_languagetree = true

-- Formatter and Linter settings
local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup({
  {
    exe = "prettier", -- change this if you're using a different formatter
    filetypes = { "lua", "javascript", "typescript", "html", "css", "vue", "svelte" },
  },
})

local linters = require "lvim.lsp.null-ls.linters"
linters.setup({
  {
    exe = "eslint", -- change this if you're using a different linter
    filetypes = { "javascript", "typescript", "html", "css", "vue", "svelte" },
  },
})


-- Plugins
lvim.plugins = {
  {
    "windwp/nvim-ts-autotag",
    config = function()
      require("nvim-ts-autotag").setup()
    end,
  },
  {"tpope/vim-surround"},
  { "mattn/emmet-vim" },
  { "ellisonleao/gruvbox.nvim" },
  { "sainnhe/edge" },
  { "Mofiqul/dracula.nvim" },
  { "metakirby5/codi.vim" },
  { "kqito/vim-easy-replace" },
  {
    "norcalli/nvim-colorizer.lua",
    config = function()
      require('colorizer').setup()
    end,
  },
  {
    "phaazon/hop.nvim",
    event = "BufRead",
    config = function()
      require("hop").setup()
      vim.api.nvim_set_keymap("", "f", ":HopChar2<cr>", { silent = true })
      vim.api.nvim_set_keymap("", "F", ":HopWord<cr>", { silent = true })
    end
  },
  {
    "f-person/auto-dark-mode.nvim",
    config = function()
      local auto_dark_mode = require('auto-dark-mode')

      auto_dark_mode.setup({
        update_interval = 1000,
        set_dark_mode = function()
          vim.api.nvim_set_option('background', 'dark')
        end,
        set_light_mode = function()
          vim.api.nvim_set_option('background', 'light')
        end,
      })

      auto_dark_mode.init()
    end,
  },

}

