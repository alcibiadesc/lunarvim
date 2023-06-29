
-- Constants
local filetypes_common = { "lua", "javascript", "typescript", "html", "css", "vue", "svelte" }
local treesitter_installed_languages = { "bash", "c", "json", "python", "tsx", "rust", "java", "yaml", unpack(filetypes_common) }

-- Setup general configurations
local function setup_general_config()
  lvim.log.level = "warn"
  lvim.format_on_save.enabled = true
  lvim.colorscheme = "edge"
  vim.opt.relativenumber = true
  lvim.keys.normal_mode["<Space><Space>"] = ":NvimTreeToggle<CR>"
end

-- Set key mappings
local function set_key_mappings()
  local key_mappings = {
    n = {
      { '<leader>V', ':split<CR>' },
      { '<leader>v', ':vsplit<CR>' },
      { '<', ':bprev<CR>' },
      { '>', ':bnext<CR>' },
    },
  }

  for mode, mappings in pairs(key_mappings) do
    for _, map in pairs(mappings) do
      vim.api.nvim_set_keymap(mode, map[1], map[2], { noremap = true, silent = true })
    end
  end
end

-- Setup plugins
local function setup_plugins()
  lvim.builtin.alpha.active = true
  lvim.builtin.alpha.mode = "dashboard"
  lvim.builtin.terminal.active = true
  lvim.builtin.nvimtree.setup.view.side = "left"
  lvim.builtin.nvimtree.setup.renderer.icons.show.git = true 
end

-- Setup treesitter
local function setup_treesitter()
  lvim.builtin.treesitter.ensure_installed = treesitter_installed_languages
  lvim.builtin.treesitter.ignore_install = { "haskell" }
  lvim.builtin.treesitter.highlight.enable = true
  lvim.builtin.treesitter.highlight.use_languagetree = true
end

-- Setup LSP
local function setup_lsp()
  lvim.lsp.installer.setup.ensure_installed = { "svelte" }
  local lsp_opts = {}
  require("lvim.lsp.manager").setup("tailwindcss", lsp_opts)
  require("lvim.lsp.manager").setup("eslint", lsp_opts)
end

-- Setup formatter and linter
local function setup_formatter_linter()
  local formatters = require "lvim.lsp.null-ls.formatters"
  formatters.setup({
    {
      exe = "prettier",
      filetypes = filetypes_common,
    },
  })

  local linters = require "lvim.lsp.null-ls.linters"
  linters.setup({
    {
      exe = "eslint",
      filetypes = filetypes_common,
    },
  })
end

-- Define plugins
local function define_plugins()
  lvim.plugins = {
    -- Essentials
    { "windwp/nvim-ts-autotag", config = function() require("nvim-ts-autotag").setup() end },
    {"tpope/vim-surround"},
    { "mattn/emmet-vim" },

    -- Themes
    { "ellisonleao/gruvbox.nvim" },
    { "sainnhe/edge" },
    { "Mofiqul/dracula.nvim" },

    -- Utilities
    { "metakirby5/codi.vim" },
    --...
  }
end

-- Call the functions
setup_general_config()
set_key_mappings()
setup_plugins()
setup_treesitter()
setup_lsp()
setup_formatter_linter()
define_plugins()

-- Extra plugins with configurations
table.insert(lvim.plugins,
  {
    "norcalli/nvim-colorizer.lua",
    config = function()
      require('colorizer').setup()
    end,
  }
)

table.insert(lvim.plugins,
  {
    "phaazon/hop.nvim",
    event = "BufRead",
    config = function()
      require("hop").setup()
      vim.api.nvim_set_keymap("", "f", ":HopChar2<cr>", { silent = true })
      vim.api.nvim_set_keymap("", "F", ":HopWord<cr>", { silent = true })
    end
  }
)

table.insert(lvim.plugins,
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
  }
)

