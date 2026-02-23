return {
  'folke/tokyonight.nvim',
  priority = 1000,
  config = function()
    require('tokyonight').setup {
      styles = {
        comments = { italic = false },
      },
    }

    vim.cmd.colorscheme 'tokyonight'
    vim.api.nvim_set_hl(0, 'Comment', { fg = '#efc3ca' })
  end,
}
