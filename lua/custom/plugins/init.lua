-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
vim.o.guifont = 'FiraMono_Nerd_Font:h15'
vim.opt.termguicolors = true

-- uncomment to disable Italians
-- local hl_groups = vim.api.nvim_get_hl(0, {})
--
-- for key, hl_group in pairs(hl_groups) do
--   if hl_group.italic then
--     vim.api.nvim_set_hl(0, key, vim.tbl_extend('force', hl_group, { italic = false }))
--   end
-- end

return {
  {
    'danielfalk/smart-open.nvim',
    branch = '0.2.x',
    config = function()
      require('telescope').load_extension 'smart_open'
    end,
    dependencies = {
      'kkharji/sqlite.lua',
      -- Only required if using match_algorithm fzf
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    },
  },

  {
    'nvim-telescope/telescope-project.nvim',
  },
}
