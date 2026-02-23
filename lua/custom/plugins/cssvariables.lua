return {
  'neovim/nvim-lspconfig',
  opts = function(_, opts)
    opts.setup = opts.setup or {}
    opts.setup.cssvariables = function()
      require('lspconfig').cssvariables.setup {
        cmd = { 'css-variables-server', '--stdio' },
        filetypes = { 'css', 'scss', 'less' },
        root_dir = require('lspconfig.util').root_pattern('package.json', '.git', '.'),
      }
      return true
    end
    return opts
  end,
}
