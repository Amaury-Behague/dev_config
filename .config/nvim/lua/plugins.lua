-- Install and setup all plugins
-- Only the basic config is done here, specific language tools setup and config is done separately.

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- plugin installation
require("lazy").setup({
    {"catppuccin/nvim", name = "catppuccin", priority = 1000},
    "lewis6991/gitsigns.nvim",
    "sindrets/diffview.nvim",
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig",
    "hrsh7th/nvim-cmp",
    "hrsh7th/cmp-nvim-lsp",
    "saadparwaiz1/cmp_luasnip",
    "L3MON4D3/LuaSnip",
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
    "nvim-treesitter/nvim-treesitter",
    "mfussenegger/nvim-dap",
    "nvim-neotest/nvim-nio",
    "rcarriga/nvim-dap-ui",
    "jay-babu/mason-nvim-dap.nvim",
    "nvimtools/none-ls.nvim",
    "jay-babu/mason-null-ls.nvim",
    "nvim-tree/nvim-tree.lua",
    "nvim-tree/nvim-web-devicons",
    "numToStr/Comment.nvim",
    "m4xshen/autoclose.nvim",
    {
        "linux-cultist/venv-selector.nvim",
        branch = "regexp", -- This is the regexp branch, use this for the new version
    },
},
{
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
    cache = {
      enabled = true,
    },
    -- profiling = {
    --   enabled = true,
    --   threshold = 5, -- ms
    -- },
  }
})

-- color scheme setup
vim.cmd.colorscheme("catppuccin")

-- gitsigns setup
require("gitsigns").setup()

-- diffview setup
local diffview = require("diffview")
diffview.setup({ use_icons = false })

-- plenary setup
require("plenary.async")

-- comment setup -- comment lines with 'gcc'
require("Comment").setup()

-- telescope setup
local telescope_builtin = require("telescope.builtin")
local telescope_actions = require("telescope.actions")
require("telescope").setup({
    defaults = {
        file_ignore_patterns = { ".pb.go$" },
    },
    pickers = {
        live_grep = {
            mappings = {
                i = {
                    ["<C-Down>"] = telescope_actions.cycle_history_next,
                    ["<C-Up>"] = telescope_actions.cycle_history_prev,
                },
            },
        },
    },
})

-- treesitter setup
require("nvim-treesitter.configs").setup({
    -- A list of parser names, or "all" (the five listed parsers should always be installed)
    ensure_installed = { "python", "lua", "go", "rust" },

    -- Install parsers synchronously (only applied to `ensure_installed`)
    sync_install = false,

    -- Automatically install missing parsers when entering buffer
    -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
    auto_install = true,

    -- List of parsers to ignore installing (or "all")
    ignore_install = { "javascript" },

    ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
    -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

    highlight = {
        enable = true,

        -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
        -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
        -- the name of the parser)
        -- list of language that will be disabled
        disable = {},
        -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
        disable = function(lang, buf)
            local max_filesize = 100 * 1024 -- 100 KB
            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > max_filesize then
                return true
            end
        end,

        -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
        -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
        -- Using this option may slow down your editor, and you may see some duplicate highlights.
        -- Instead of true it can also be a list of languages
        additional_vim_regex_highlighting = false,
    },
})

-- dap-ui setup
local dapui = require("dapui")
dapui.setup()

-- nvim-tree setup
require("nvim-tree").setup({
    view = {
        width = 50,
    },
})
local tree_api = require("nvim-tree.api")

-- autoclose setup
require("autoclose").setup({
    keys = {
        ["("] = { escape = false, close = false, pair = "()" },
        ["["] = { escape = false, close = false, pair = "[]" },
        ["{"] = { escape = false, close = true, pair = "{}" },

        [">"] = { escape = true, close = false, pair = "<>" },
        [")"] = { escape = true, close = false, pair = "()" },
        ["]"] = { escape = true, close = false, pair = "[]" },
        ["}"] = { escape = true, close = false, pair = "{}" },

        ['"'] = { escape = true, close = true, pair = '""' },
        ["'"] = { escape = true, close = true, pair = "''" },
        ["`"] = { escape = true, close = true, pair = "``" },
    },
    options = {
        disabled_filetypes = { "text" },
        disable_when_touch = false,
        touch_regex = "[%w(%[{]",
        pair_spaces = false,
        auto_indent = true,
        disable_command_mode = false,
    },
})

-- venv-selector setup
require("venv-selector").setup()

return {
    telescope_builtin = telescope_builtin,
    tree_api = tree_api,
    dapui = dapui,
    diffview = diffview,
}
