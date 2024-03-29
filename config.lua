-- Constants
local filetypes_common = { "lua", "javascript", "typescript", "html", "css", "vue", "svelte" }
local treesitter_installed_languages = { "bash", "c", "json", "python", "tsx", "rust", "java", "yaml", unpack(filetypes_common) }

-- Setup general configurations
local function setup_general_config()
  -- Set log level, enable format on save and set colorscheme
  lvim.log.level = "warn"
  lvim.format_on_save.enabled = true
  lvim.colorscheme = "edge"
  
  -- Enable relative number
  vim.opt.relativenumber = true
  
  -- Set nvim tree toggle mapping
  lvim.keys.normal_mode["<Space><Space>"] = ":NvimTreeToggle<CR>"
end

-- Set key mappings
local function set_key_mappings()
  -- Set key mappings for window splits and hardtime toggle
  lvim.builtin.which_key.mappings["V"] = { ":split<CR>", "split window vertically" }
  lvim.builtin.which_key.mappings["v"] = { ":vsplit<CR>", "split window horizontally" }
  lvim.builtin.which_key.mappings["x"] = { ":HardTimeToggle<CR>", "toggle hardtime" }
  
-- Harpoon KeyMap
lvim.builtin.which_key.mappings["9"] = {":lua require('harpoon.ui').toggle_quick_menu()<CR>", "open harpoon"}
lvim.builtin.which_key.mappings["8"] = { ":lua require('harpoon.mark').add_file()<CR>", "Add file" }
lvim.builtin.which_key.mappings["1"] = { ":lua require('harpoon.ui').nav_file(1)<CR>", "Navigate to file 1" }
lvim.builtin.which_key.mappings["2"] = { ":lua require('harpoon.ui').nav_file(2)<CR>", "Navigate to file 2" }
lvim.builtin.which_key.mappings["3"] = { ":lua require('harpoon.ui').nav_file(3)<CR>", "Navigate to file 3" }
lvim.builtin.which_key.mappings["4"] = { ":lua require('harpoon.ui').nav_file(4)<CR>", "Navigate to file 4" }
lvim.builtin.which_key.mappings["5"] = { ":lua require('harpoon.ui').nav_file(5)<CR>", "Navigate to file 5" }
lvim.builtin.which_key.mappings["6"] = { ":lua require('harpoon.ui').nav_file(6)<CR>", "Navigate to file 6" }
lvim.builtin.which_key.mappings["7"] = { ":lua require('harpoon.ui').nav_file(7)<CR>", "Navigate to file 7" }


-- Set keymapping for Telescope > live grep

lvim.builtin.which_key.mappings["lg"] = {
    "<cmd>Telescope live_grep<CR>", 
    "Run Telescope live grep"
}

-- Set Key mapping for todo-comments 
lvim.builtin.which_key.mappings["T"] = { ":TodoTelescope<CR>", "Open todo comments with telescope" }


-- Set keymapping telescope
lvim.builtin.which_key.mappings["t"] = { ":Telescope<CR>", "Telescope" }


-- Set key mapping for Oil file explorer
  lvim.builtin.which_key.mappings["o"] = { ":Oil<CR>", "Open Oil File Explorer" }
end


-- Set special key mappings
local function set_key_mappings_special()
  -- Define special key mappings for buffer navigation
  local key_mappings = {
    n = {
      { '<', ':bprev<CR>' },
      { '>', ':bnext<CR>' },
    },
  }

  -- Set the defined key mappings
  for mode, mappings in pairs(key_mappings) do
    for _, map in pairs(mappings) do
      vim.api.nvim_set_keymap(mode, map[1], map[2], { noremap = true, silent = true })
    end
  end
end

-- Setup plugins
local function setup_plugins()
  -- Enable and configure alpha plugin
  lvim.builtin.alpha.active = true
  lvim.builtin.alpha.mode = "dashboard"
end

-- Setup treesitter
local function setup_treesitter()
  -- Configure installed languages and enable highlighting
  lvim.builtin.treesitter.ensure_installed = treesitter_installed_languages
  lvim.builtin.treesitter.ignore_install = { "haskell" }
  lvim.builtin.treesitter.highlight.enable = true
  lvim.builtin.treesitter.highlight.use_languagetree = true
end

-- Setup LSP
local function setup_lsp()
  -- Ensure Svelte LSP is installed and setup LSP for svelte, tailwindcss and eslint
  lvim.lsp.installer.setup.ensure_installed = { "svelte" }
  local lsp_opts = {}
  require("lvim.lsp.manager").setup("svelte", lsp_opts)
  require("lvim.lsp.manager").setup("tailwindcss", lsp_opts)
  require("lvim.lsp.manager").setup("eslint", lsp_opts)
end

-- Setup formatter and linter
local function setup_formatter_linter()
  -- Setup prettier formatter and eslint linter for common filetypes
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
  -- Define essential, theme and utility plugins
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
    {"kqito/vim-easy-replace", event = "BufRead"}, --leader ra & leader rc

    -- Productivity
    {"takac/vim-hardtime", event = "VeryLazy"},
    --...

  }

  -- Define extra plugins with their configurations
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


  table.insert(lvim.plugins,
  {
    'stevearc/oil.nvim',
     event = "VeryLazy",
    opts = {},
    -- Optional dependencies
    dependencies = { "nvim-tree/nvim-web-devicons" },
  }
  )


  table.insert(lvim.plugins,
  {
    'ThePrimeagen/harpoon',
    dependencies = { "nvim-lua/plenary.nvim" },
     event = "VeryLazy",
    opts = {},
  }
  )


  table.insert(lvim.plugins,
  {
  "folke/todo-comments.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },

     event = "VeryLazy",
  opts = 

    {
    }
  }
  )


-- indent-blankline
  table.insert(lvim.plugins, {
"lukas-reineke/indent-blankline.nvim"
  })


vim.opt.list = true
vim.opt.listchars:append "space:⋅"

require("indent_blankline").setup {
    space_char_blankline = " ",
    show_current_context = true,
    show_current_context_start = true,
}


end

-- Main function
local function main()
  setup_general_config()
  set_key_mappings()
  set_key_mappings_special()
  setup_plugins()
  setup_treesitter()
  setup_lsp()
  setup_formatter_linter()
  define_plugins()
end

main()

