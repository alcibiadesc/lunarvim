
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
  lvim.builtin.which_key.mappings["V"] = { ":split<CR>", "split window vertically" }
  lvim.builtin.which_key.mappings["v"] = { ":vsplit<CR>", "split window horizontally" }
  lvim.builtin.which_key.mappings["x"] = { ":HardTimeToggle<CR>", "toggle hardtime" }
end


-- Set special key mappings
local function set_key_mappings_special()
  local key_mappings = {
    n = {
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
    { "windwp/nvim-ts-autotag", event = "BufRead", config = function() require("nvim-ts-autotag").setup() end },

    -- Themes
    { "ellisonleao/gruvbox.nvim", event = "VeryLazy" },
    { "sainnhe/edge" },
    { "Mofiqul/dracula.nvim", event = "VeryLazy" },

    -- Utilities
    { "metakirby5/codi.vim", cmd = "Codi"  },
    { "romainl/vim-cool" },  

    -- Productivity
    {"takac/vim-hardtime", event = "VeryLazy"},
    --...

  }
end

-- Call the functions
setup_general_config()
set_key_mappings()
set_key_mappings_special()
setup_plugins()
setup_treesitter()
setup_lsp()
setup_formatter_linter()
define_plugins()


-- Extra plugins with configurations
table.insert(lvim.plugins,
  {
    "norcalli/nvim-colorizer.lua",
    event = "VeryLazy",
    config = function()
      require('colorizer').setup()
    end,
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

table.insert(lvim.plugins,
{
  "folke/flash.nvim",
  event = "VeryLazy",
  ---@type Flash.Config
  opts = {},
  keys = {
    {
      "s",
      mode = { "n", "x", "o" },
      function()
        require("flash").jump()
      end,
      desc = "Flash",
    },
    {
      "S",
      mode = { "n", "o", "x" },
      function()
        require("flash").treesitter()
      end,
      desc = "Flash Treesitter",
    },
    {
      "r",
      mode = "o",
      function()
        require("flash").remote()
      end,
      desc = "Remote Flash",
    },
    {
      "R",
      mode = { "o", "x" },
      function()
        require("flash").treesitter_search()
      end,
      desc = "Flash Treesitter Search",
    },
    {
      "<c-s>",
      mode = { "c" },
      function()
        require("flash").toggle()
      end,
      desc = "Toggle Flash Search",
    },
  },
}


)


-- emmet config
local lspconfig = require('lspconfig')
local configs = require('lspconfig/configs')
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

lspconfig.emmet_ls.setup({
    capabilities = capabilities,
    filetypes = filetypes_common,
    init_options = {
      html = {
        options = {
          ["bem.enabled"] = true,
        },
      },
    }
})

