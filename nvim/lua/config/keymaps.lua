-- ═══════════════════════════════════════════════════════════════════════════════
-- CUSTOM KEYMAPS CONFIGURATION
-- ═══════════════════════════════════════════════════════════════════════════════
-- Because default keybindings are for people who enjoy unnecessary suffering

-- Set leader key to comma (because life's too short for backslash gymnastics)
vim.g.mapleader = ','

-- Convenience aliases for cleaner code (readability is a virtue)
local map = vim.api.nvim_set_keymap
local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- ═══════════════════════════════════════════════════════════════════════════════
-- FUNCTION KEY MAPPINGS - The F-series Arsenal
-- ═══════════════════════════════════════════════════════════════════════════════

-- F12: Show custom keymaps (meta-programming at its finest)
keymap('n', '<F12>', function()
  require('tools.keymap_helper').show_custom_keymaps()
end, { desc = "Display custom keymaps in popup", noremap = true, silent = true })

-- F2: Toggle NERDTree (file explorer for the graphically inclined)
map('n', '<F2>', ':NERDTreeToggle<CR>', opts)

-- F3: Insert 42 header (because institutional compliance matters)
map('n', '<F3>', ':Stdheader<CR>', opts)

-- F5: Run Norminette (the code style enforcer that haunts 42 students' dreams)
map('n', '<F5>', ':Norminette<CR>', opts)

-- F6: Compile with extensive warnings (paranoia-level compilation)
-- Wall + Wextra + pedantic = maximum suffering during development, minimal bugs in production
map('n', '<F6>', 
  ':!cc -Wall -Wextra -pedantic -g3 *.c -I. && echo "✅ Compiled successfully" || echo "❌ Compilation failed"<CR>', 
  opts)

-- F7: Run Valgrind analysis (memory leak detective mode)
map('n', '<F7>', 
  ':lua package.loaded["tools.valgrind"] = nil; require("tools.valgrind").run_valgrind()<CR>', 
  opts)

-- F8: Highlight Valgrind errors (visual representation of your memory management sins)
map('n', '<F8>', 
  ':lua package.loaded["tools.valgrind"] = nil; require("tools.valgrind").highlight_errors()<CR>', 
  opts)

-- F9: Clear Valgrind highlights (redemption and clean slate)
map('n', '<F9>', 
  ':lua require("tools.valgrind").clear_highlights()<CR>', 
  opts)

-- ═══════════════════════════════════════════════════════════════════════════════
-- DEBUG ADAPTER PROTOCOL (DAP) KEYMAPS
-- ═══════════════════════════════════════════════════════════════════════════════
-- Professional debugging for those who've evolved beyond printf debugging

-- Safely load DAP before defining keymaps (defensive programming is best programming)
local dap_ok, dap = pcall(require, 'dap')
if dap_ok then
  -- Debug session control mappings using leader key combinations
  local debug_opts = { noremap = true, silent = true }
  
  -- Core debug session controls
  map('n', '<leader>dd', "<Cmd>lua require'dap'.continue()<CR>", 
    vim.tbl_extend('force', debug_opts, { desc = "Debug: Start/Continue execution" }))
  
  map('n', '<leader>do', "<Cmd>lua require'dap'.step_over()<CR>", 
    vim.tbl_extend('force', debug_opts, { desc = "Debug: Step over current line" }))
  
  map('n', '<leader>di', "<Cmd>lua require'dap'.step_into()<CR>", 
    vim.tbl_extend('force', debug_opts, { desc = "Debug: Step into function call" }))
  
  map('n', '<leader>du', "<Cmd>lua require'dap'.step_out()<CR>", 
    vim.tbl_extend('force', debug_opts, { desc = "Debug: Step out of current function" }))
  
  -- Breakpoint management (strategic pause points for investigation)
  map('n', '<leader>db', "<Cmd>lua require'dap'.toggle_breakpoint()<CR>", 
    vim.tbl_extend('force', debug_opts, { desc = "Debug: Toggle breakpoint" }))
  
  map('n', '<leader>dB', "<Cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>", 
    vim.tbl_extend('force', debug_opts, { desc = "Debug: Set conditional breakpoint" }))
  
  -- Debug session utilities
  map('n', '<leader>dr', "<Cmd>lua require'dap'.repl.open()<CR>", 
    vim.tbl_extend('force', debug_opts, { desc = "Debug: Open interactive REPL" }))
  
  map('n', '<leader>dl', "<Cmd>lua require'dap'.run_last()<CR>", 
    vim.tbl_extend('force', debug_opts, { desc = "Debug: Repeat last debug session" }))
else
  -- Graceful degradation when DAP is unavailable
  vim.notify("DAP not available - debugging keymaps disabled", vim.log.levels.WARN)
end
