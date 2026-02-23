return {
  'windwp/nvim-ts-autotag',
  event = 'InsertEnter',
  ft = { 'html', 'javascriptreact', 'typescriptreact' },
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  config = function()
    require('nvim-ts-autotag').setup()
  end,
}
