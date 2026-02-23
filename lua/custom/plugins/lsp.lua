return {
  'neovim/nvim-lspconfig',
  dependencies = {
    { 'williamboman/mason.nvim', opts = {} },
    'williamboman/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    { 'j-hui/fidget.nvim', opts = {} },
    'saghen/blink.cmp',
  },
  opts = {
    servers = {
      gopls = {},
      pyright = {},
      cssls = {},
      lua_ls = {
        settings = {
          Lua = {
            completion = { callSnippet = 'Replace' },
          },
        },
      },
    },
  },
  config = function(_, opts)
    local lspconfig = require 'lspconfig'
    local capabilities = require('blink.cmp').get_lsp_capabilities()
    local servers = opts.servers or {}
    
    require('mason').setup()
    require('mason-tool-installer').setup { ensure_installed = vim.tbl_keys(servers) }

    -- Disable Mason's auto-enable to ensure our custom configuration wins
    -- and to prevent the "Ghost Instance" issue on Neovim 0.11
    require('mason-lspconfig').setup({
      automatic_enable = false,
    })

    -- Silence the deprecation warning for nvim-lspconfig on Nvim 0.11+
    -- We're using the older setup method because the native one isn't 
    -- playing nice with modularity and Mason-LSPConfig yet.
    local original_notify = vim.notify
    vim.notify = function(msg, level, opts)
      if type(msg) == 'string' and msg:find("require%('lspconfig'%)") then
        return
      end
      original_notify(msg, level, opts)
    end

    -- Manually setup servers from the merged opts.servers table
    -- This ensures our custom root_dir and settings are applied correctly.
    for name, server_opts in pairs(servers) do
      server_opts.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server_opts.capabilities or {})
      lspconfig[name].setup(server_opts)
    end

    -- Restore original notify
    vim.notify = original_notify

    -- Global LspAttach for keymaps
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
      callback = function(event)
        local map = function(keys, func, desc)
          vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
        end
        map('grn', vim.lsp.buf.rename, 'Rename')
        map('gra', vim.lsp.buf.code_action, 'Code Action')
        map('grr', require('telescope.builtin').lsp_references, 'References')
        map('gri', require('telescope.builtin').lsp_implementations, 'Implementations')
        map('grd', require('telescope.builtin').lsp_definitions, 'Definitions')
      end,
    })
  end,
}
