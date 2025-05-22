-- options.lua
vim.o.autoindent = true
vim.o.smartindent = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.softtabstop = 4
vim.wo.number = true
vim.o.encoding = 'utf-8'
vim.wo.cursorline = true
vim.o.mouse = 'a'
vim.o.hlsearch = true
vim.o.incsearch = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.ruler = true
vim.o.showcmd = true
vim.cmd('syntax on')
vim.o.termguicolors = true
vim.cmd('colorscheme everforest')

-- ALE config
vim.g.ale_linters = {
  c = {'gcc', 'clang', 'cppcheck', 'clangtidy'},
  cpp = {'g++', 'clang', 'cppcheck', 'clangtidy'}
}
vim.g.ale_fixers = {
  c = {'clang-format'},
  cpp = {'clang-format'}
}
vim.g.ale_c_cpp_clangtidy_options = '-checks=*,-clang-analyzer-alpha*'
vim.g.ale_c_cpp_cppcheck_options = '--enable=all'
vim.g.ale_sign_error = '✗'
vim.g.ale_sign_warning = '⚠'
vim.g.ale_virtualtext_cursor = 1
vim.g.ale_echo_msg_format = '[%linter%] %s [%severity%]'
vim.g.ale_completion_enabled = 0
vim.g.ale_set_balloons = 0

-- Disable intrusive autocomplete popups
--vim.o.completeopt = vim.o.completeopt:gsub('preview', '')
--vim.o.completeopt = vim.o.completeopt:gsub('menu', '')
--vim.o.completeopt = vim.o.completeopt:gsub('menuone', '')
--vim.o.completeopt = vim.o.completeopt:gsub('longest', '')
vim.o.completeopt = 'menu,menuone,noselect'
