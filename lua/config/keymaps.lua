local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

map('n', '<F12>', ':lua require("tools.keymap_helper").show_keymaps()<CR>', opts)
map('n', '<F2>', ':NERDTreeToggle<CR>', opts)
map('n', '<F3>', ':Stdheader<CR>', opts)
map('n', '<F5>', ':Norminette<CR>', opts)
map('n', '<F6>', ':!cc -Wall -Wextra -pedantic -g3 % -o a.out && echo "Compiled without errors." || echo "Compilation failed."<CR>', opts)
map('n', '<F7>', ':lua package.loaded["tools.valgrind"] = nil; require("tools.valgrind").run_valgrind()<CR>', opts)
map('n', '<F8>', ':lua package.loaded["tools.valgrind"] = nil; require("tools.valgrind").highlight_errors()<CR>', opts)
map('n', '<F9>', ':lua require("tools.valgrind").clear_highlights()<CR>', opts)

