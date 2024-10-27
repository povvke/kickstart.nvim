-- idk if I need this for blink.nvim
-- local capabilities = vim.lsp.protocol.make_client_capabilities()
-- local cmp_nvim_lsp = require("plugin_loader").load("cmp_nvim_lsp")
-- if cmp_nvim_lsp ~= nil then
--   capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
--   capabilities.textDocument.completion.completionItem.snippetSupport = true
-- end

-- oil.nvim
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })



-- keybinds
vim.keymap.set('n', '<leader>bk', ':bd<CR>', { desc = 'Kill Buffer' })
vim.keymap.set('n', '<leader>bn', ':bn<CR>', { desc = 'Next Buffer' })
vim.keymap.set('n', '<leader>bi', ':lua require("buffer_manager.ui").toggle_quick_menu()<CR>',
  { desc = "Interactive buffer manager" })
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
