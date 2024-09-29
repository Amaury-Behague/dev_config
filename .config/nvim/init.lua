-- install and setup all plugins
local plugins = require("plugins")

-- custom language tools, linting, formatting and completion setup
require("lint_format_completion")

-- disable netrw and enable hightlight groups (for nvim-tree)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.termguicolors = true

-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set("n", "F", vim.diagnostic.open_float)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspConfig", {}),
    callback = function(ev)
        -- Buffer local mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local opts = { buffer = ev.buf }
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
        vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
        vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)
        vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
        vim.keymap.set("n", "<leader>wl", function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, opts)
        vim.keymap.set("n", "D", vim.lsp.buf.type_definition, opts)
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
        vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
        vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
        vim.keymap.set("n", "<leader>f", function()
            vim.lsp.buf.format({ async = true })
        end, opts)
    end,
})

vim.lsp.set_log_level("warn") -- use "debug" instead when needed

-- remap leader char to space
vim.g.mapleader = " "

-- telescope shortcuts
vim.keymap.set("n", "<leader>ff", plugins.telescope_builtin.find_files, {})
vim.keymap.set("n", "<leader>fg", plugins.telescope_builtin.live_grep, {})
vim.keymap.set("n", "<leader>fb", plugins.telescope_builtin.buffers, {})
vim.keymap.set("n", "<leader>fh", plugins.telescope_builtin.help_tags, {})
vim.keymap.set("n", "<C-p>", plugins.telescope_builtin.find_files, {})

-- diffview shortcuts
vim.keymap.set("n", "<leader>df", plugins.diffview.open, {})

-- dapui shortcuts
vim.keymap.set("n", "<leader>db", plugins.dapui.toggle)

-- nvim-tree shortcuts
vim.keymap.set("n", "<leader>t", plugins.tree_api.tree.toggle)

-- Personal shortcuts config
vim.keymap.set("v", "<leader>y", '"+y') -- copy to clipboard
vim.keymap.set("n", "n", "nzz")         -- auto-center when searching
vim.keymap.set("n", "n", "nzz")         -- auto-center when searching
vim.keymap.set("n", "<C-d>", "<C-d>zz") -- auto-center when jumping half page
vim.keymap.set("n", "<C-u>", "<C-u>zz") -- auto-center when jumping half page
vim.keymap.set("v", "<", "<gv")         -- keep selection when detenting
vim.keymap.set("v", ">", ">gv")         -- keep selection when indenting

-- Vim options config
vim.opt.nu = true -- line number
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

vim.opt.wrap = false
vim.opt.swapfile = false

vim.opt.hlsearch = true -- switch to false to suppress search highlight
vim.opt.incsearch = true

vim.opt.scrolloff = 8       -- min 8 lines at the bottom
vim.opt.colorcolumn = "120" -- highlight column 120

vim.opt.updatetime = 50
