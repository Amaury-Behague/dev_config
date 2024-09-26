--[[
Setup everything that's needed for programming:
 - linting and formatting with none-ls (formerly null-ls),
 - auto-completion with nvim-cmp,
 - language servers with lspconfig
--]]

-- none-ls (null-ls) config for linters and formatters
local null_ls = require("null-ls")
null_ls.setup({
    sources = {
        null_ls.builtins.code_actions.proselint,
        null_ls.builtins.diagnostics.buf,
        null_ls.builtins.diagnostics.buildifier,
        null_ls.builtins.diagnostics.hadolint,
        null_ls.builtins.diagnostics.markdownlint.with({
            extra_args = { "--stdin", "--disable", "MD013" },
        }),
        null_ls.builtins.diagnostics.proselint,
        -- null_ls.builtins.diagnostics.pylint, -- can be replaced with ruff, install in local venv
        null_ls.builtins.diagnostics.semgrep,
        -- null_ls.builtins.diagnostics.staticcheck,
        null_ls.builtins.formatting.black.with({
            extra_args = { "--line-length=120", "--preview" },
        }),
        null_ls.builtins.formatting.buf,
        null_ls.builtins.formatting.buildifier,
        null_ls.builtins.formatting.gofumpt,
        -- null_ls.builtins.formatting.golines.with({
        --     extra_args = {"-m", "120"}
        -- }),
        null_ls.builtins.formatting.goimports,
        null_ls.builtins.formatting.isort.with({
            extra_args = { "--sl", "--line-length", "120" },
        }), -- install in local venv
        -- null_ls.builtins.formatting.rustfmt, -- not supported by none-ls
        null_ls.builtins.formatting.mdformat,
        null_ls.builtins.formatting.terraform_fmt, -- needs manual install
        null_ls.builtins.formatting.shfmt,
        null_ls.builtins.formatting.stylua,
    },
})

-- lspconfig & nvim-cmp setup
-- Add additional capabilities supported by nvim-cmp
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Setup lspconfig and enable some language servers with the additional completion capabilities offered by nvim-cmp
local language_tools = require("language_tools")
local lspconfig = require("lspconfig")
for _, lsp in ipairs(language_tools.servers) do
    lspconfig[lsp].setup({
        -- on_attach = my_custom_on_attach,
        capabilities = capabilities,
    })
end

-- luasnip setup
local luasnip = require("luasnip")

-- nvim-cmp setup
local cmp = require("cmp")
cmp.setup({
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ["<C-u>"] = cmp.mapping.scroll_docs(-4), -- Up
        ["<C-d>"] = cmp.mapping.scroll_docs(4), -- Down
        -- C-b (back) C-f (forward) for snippet placeholder navigation.
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<CR>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
        }),
        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { "i", "s" }),
    }),
    sources = {
        { name = "nvim_lsp" },
        { name = "luasnip" },
    },
})
