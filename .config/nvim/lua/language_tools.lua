-- setup language servers and tools with mason
require("mason").setup()
local servers = { -- see https://github.com/williamboman/mason-lspconfig.nvim?tab=readme-ov-file#available-lsp-servers
    "lua_ls",
    "rust_analyzer",
    -- "gopls", -- needs go to be installed first
    "pyright",
    "bashls",
    "dockerls",
    "helm_ls",
    "marksman",
    "terraformls",
    "ts_ls",
    "yamlls",
    -- "biome", -- needs npm to be installed first
    -- "bufls", -- needs go to be installed first
}
require("mason-lspconfig").setup({
    ensure_installed = servers,
})

-- Note: null-ls isn't updated any more so we use https://github.com/nvimtools/none-ls.nvim instead as a drop-in
-- replacement. mason-null-ls continues to be updated and works with none-ls (see: https://github.com/jay-babu/mason-null-ls.nvim/issues/82)
-- Some new sources might be available here: https://github.com/nvimtools/none-ls.nvim/blob/main/doc/SOURCES.md but
-- you would have to check if they work with mason-null-ls.
require("mason-null-ls").setup({ -- see https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md
    ensure_installed = {
        "stylua",
        -- "gofumpt", -- needs go to be installed first
        -- "golines", -- needs go to be installed first
        "black",
        "jq", -- needs to be installed manually first
        -- "staticcheck",
        -- "pylint", -- can be replaced with ruff, install in local venv
        "buf",
        "markdownlint",
        "mdformat",
        "buildifier",
        "hadolint",
        "semgrep",
        -- "goimports", -- needs go to be installed first
        -- "isort", -- install in local venv
        -- "rustfmt", -- deprecated, install via rustup
        "shfmt",
        "buildifier",
        "proselint",
    },
})
-- Install manually: terraform_fmt

require("mason-nvim-dap").setup({
    ensure_installed = {
        "python",
        -- "delve", -- needs go to be installed first
    },
})

return {
    servers = servers,
}
