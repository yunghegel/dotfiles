-- General options
vim.opt.mouse = "a"
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.clipboard = "unnamedplus"
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.termguicolors = true
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.scrolloff = 8
vim.opt.updatetime = 300
vim.opt.signcolumn = "yes"
vim.g.mapleader = " "

-- Lazy.nvim setup
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({

  -- Essentials
  "nvim-lua/plenary.nvim",
  "nvim-tree/nvim-web-devicons",

 {
    "github/copilot.vim",
    config = function()
      vim.g.copilot_no_tab_map = true  -- keep Tab free for nvim-cmp

      -- Accept / dismiss suggestions
      vim.api.nvim_set_keymap("i", "<C-J>", 'copilot#Accept("\\<CR>")', { expr = true, silent = true })
      vim.api.nvim_set_keymap("i", "<C-K>", 'copilot#Dismiss()', { expr = true, silent = true })

      -- Enable for all filetypes
      vim.g.copilot_filetypes = { ["*"] = true }
    end
  },

  -- File explorer
  {
    "nvim-tree/nvim-tree.lua",
    config = function()
      require("nvim-tree").setup({
        view = { width = 30, side = "left", preserve_window_proportions = true },
        renderer = { icons = { show = { file = true, folder = true, folder_arrow = true } } },
        update_focused_file = { enable = true, update_cwd = true },
        git = { enable = true },
        actions = { open_file = { quit_on_open = false } },
      })
      vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
          require("nvim-tree.api").tree.open()
        end,
      })
    end,
  },

  -- Telescope
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("telescope").setup({
        defaults = {
          file_ignore_patterns = { "node_modules", ".git/" },
          mappings = { i = { ["<C-j>"] = "move_selection_next", ["<C-k>"] = "move_selection_previous" } },
        },
      })
      vim.keymap.set("n", "<C-p>", ":Telescope find_files<CR>", { noremap = true, silent = true })
      vim.keymap.set("n", "<C-f>", ":Telescope live_grep<CR>", { noremap = true, silent = true })
      vim.keymap.set("n", "<leader>bb", ":Telescope buffers<CR>", { noremap = true, silent = true })
      vim.keymap.set("n", "<leader>ch", ":Telescope command_history<CR>", { noremap = true, silent = true })
    end,
  },

  -- LSP
  {
    "neovim/nvim-lspconfig",
    config = function()
      local lsp_start = vim.lsp.start

      lsp_start({
        name = "pyright",
        cmd = { "pyright-langserver", "--stdio" },
        root_dir = vim.fs.dirname(vim.fs.find({ ".git", "pyproject.toml", "setup.py" }, { upward = true })[1] or vim.fn.getcwd()),
      })

      lsp_start({
        name = "ts_ls",
        cmd = { "typescript-language-server", "--stdio" },
        root_dir = vim.fs.dirname(vim.fs.find({ ".git", "package.json", "tsconfig.json" }, { upward = true })[1] or vim.fn.getcwd()),
      })
    end,
  },

  -- Autocomplete
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "onsails/lspkind-nvim",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      cmp.setup({
        snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
        mapping = cmp.mapping.preset.insert({
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then luasnip.expand_or_jump()
            else fallback() end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then luasnip.jump(-1)
            else fallback() end
          end, { "i", "s" }),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<C-d>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
        }),
        sources = cmp.config.sources({ { name = "nvim_lsp" }, { name = "luasnip" } }),
        experimental = { ghost_text = true },
      })
    end,
  },
  "L3MON4D3/LuaSnip",
  "saadparwaiz1/cmp_luasnip",

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    lazy = true,
    config = function()
      local ok, ts_configs = pcall(require, "nvim-treesitter.configs")
      if not ok then return end
      ts_configs.setup({
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },

  -- Git
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup({
        signs = { add = { text = "+" }, change = { text = "~" }, delete = { text = "_" }, topdelete = { text = "‾" }, changedelete = { text = "~" } },
        current_line_blame = true,
      })
    end,
  },

  -- UI
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({ options = { theme = "auto", section_separators = "", component_separators = "|" } })
    end,
  },
  {
    "akinsho/bufferline.nvim",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      require("bufferline").setup({ options = { numbers = "ordinal", diagnostics = "nvim_lsp" } })
      vim.keymap.set("n", "<leader>bn", ":BufferLineCycleNext<CR>", { noremap = true, silent = true })
      vim.keymap.set("n", "<leader>bp", ":BufferLineCyclePrev<CR>", { noremap = true, silent = true })
    end,
  },

  -- Utilities
  "mbbill/undotree",
  "rmagatti/auto-session",
  {
    "akinsho/toggleterm.nvim",
    config = function()
      require("toggleterm").setup({ size = 15, open_mapping = [[<C-\>]], direction = "horizontal" })
    end,
  },
  "tpope/vim-commentary",
  "tpope/vim-surround",
  "windwp/nvim-autopairs",
  "ggandor/leap.nvim",
  "folke/which-key.nvim",

  -- Markdown
  {
    "iamcco/markdown-preview.nvim",
    run = "cd app && npm install",
    ft = { "markdown" },
    config = function()
      vim.g.mkdp_auto_start = 0
      vim.g.mkdp_auto_close = 1
      vim.g.mkdp_refresh_slow = 0
    end,
  },
  {
    "zbirenbaum/copilot-cmp",
    dependencies = { "github/copilot.vim", "hrsh7th/nvim-cmp" },
    config = function()
      require("copilot_cmp").setup()
    end,
  },

  -- Colorschemes
  "EdenEast/nightfox.nvim",
  "sainnhe/everforest",
})
