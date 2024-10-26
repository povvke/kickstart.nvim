-- idk if I need this for blink.nvim
-- local capabilities = vim.lsp.protocol.make_client_capabilities()
-- local cmp_nvim_lsp = require("plugin_loader").load("cmp_nvim_lsp")
-- if cmp_nvim_lsp ~= nil then
--   capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
--   capabilities.textDocument.completion.completionItem.snippetSupport = true
-- end

-- oil.nvim
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

-- Example: Lazy load based on filetype
local lspconfig = require('lspconfig')

-- Set up specific LSP when a specific file type is detected
vim.api.nvim_create_autocmd("FileType", {
  pattern = "lua",
  callback = function()
    lspconfig.lua_ls.setup {
      on_init = function(client)
        if client.workspace_folders then
          local path = client.workspace_folders[1].name
          if vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc') then
            return
          end
        end

        client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
          runtime = {
            -- Tell the language server which version of Lua you're using
            -- (most likely LuaJIT in the case of Neovim)
            version = 'LuaJIT'
          },
          -- Make the server aware of Neovim runtime files
          workspace = {
            checkThirdParty = false,
            library = {
              vim.env.VIMRUNTIME
              -- Depending on the usage, you might want to add additional paths here.
              -- "${3rd}/luv/library"
              -- "${3rd}/busted/library",
            }
            -- or pull in all of 'runtimepath'. NOTE: this is a lot slower and will cause issues when working on your own configuration (see https://github.com/neovim/nvim-lspconfig/issues/3189)
            -- library = vim.api.nvim_get_runtime_file("", true)
          }
        })
      end,
      settings = {
        Lua = {}
      }
    }
  end
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "astro",
  callback = function()
    lspconfig.astro.setup {}
  end
})

lspconfig.nil_ls.setup {}

-- keybinds
vim.keymap.set('n', '<leader>bk', ':bd<CR>', { desc = 'Kill Buffer' })
vim.keymap.set('n', '<leader>bn', ':bn<CR>', { desc = 'Next Buffer' })
vim.keymap.set('n', '<leader>bp', ':bp<CR>', { desc = 'Previous Buffer' })
vim.keymap.set('n', '<Tab>', ':bn<CR>', { desc = 'Next Buffer' })
vim.keymap.set('n', '<S-Tab>', ':bp<CR>', { desc = 'Previous Buffer' })

vim.keymap.set('n', '<leader>gg', '<CMD>Neogit<CR>')

-- emacs keybinds
vim.keymap.set({ 'n', 'v', 'i', 'c', 'o' }, '<C-g>', '<Esc>')
vim.keymap.set({ 'i' }, '<C-e>', "<End>")
vim.keymap.set({ 'i' }, '<C-a>', "<Home>")
vim.keymap.set({ 'i' }, '<C-p>', "<Down>")
vim.keymap.set({ 'i' }, '<C-n>', "<Up>")
vim.keymap.set({ 'i' }, '<C-f>', "<Right>")
vim.keymap.set({ 'i' }, '<C-b>', "<Left>")

-- exit in a quick way
vim.keymap.set('n', '<leader>qq', ':qa<CR>')

-- tree-sitter folding
vim.opt.foldlevel = 20
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"

-- For new shell.nix files
vim.api.nvim_create_autocmd("BufNewFile", {
  pattern = "shell.nix",
  callback = function()
    -- Insert the template text
    local template = [[
{ pkgs ? import <nixpkgs> {} }:

with pkgs;

mkShell {
  buildInputs = [

  ];
}
]]
    vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(template, "\n"))

    -- Move the cursor to the correct position inside the brackets on line 7
    vim.fn.setpos('.', { 0, 7, 5, 0 }) -- Go to line 7, column 5, and enter insert mode
    vim.cmd("startinsert")
  end
})

return {
  { import = 'custom.plugins.plugins' },
}
