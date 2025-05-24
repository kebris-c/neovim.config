-- ═══════════════════════════════════════════════════════════════════════════════
-- NEOVIM EDITOR OPTIONS CONFIGURATION
-- ═══════════════════════════════════════════════════════════════════════════════
-- Making Neovim behave like a civilized text editor instead of a digital typewriter

-- ┌─────────────────────────────────────────────────────────────────────────────┐
-- │ INDENTATION & FORMATTING - The Holy Wars Section                           │
-- └─────────────────────────────────────────────────────────────────────────────┘
-- Because spaces vs tabs is the programming equivalent of console wars

vim.o.autoindent = true    -- Automatic indentation (because manual labor is for savages)
vim.o.smartindent = true   -- Context-aware indentation (AI before AI was cool)
vim.o.tabstop = 4          -- Tab display width (4 spaces - the reasonable choice)
vim.o.shiftwidth = 4       -- Indent width for auto-indent operations
vim.o.softtabstop = 4      -- Backspace behavior for tab-like spaces
vim.o.expandtab = true     -- Convert tabs to spaces (join the space master race)

-- ┌─────────────────────────────────────────────────────────────────────────────┐
-- │ VISUAL ENHANCEMENTS - Making Things Pretty                                 │
-- └─────────────────────────────────────────────────────────────────────────────┘
-- Because staring at plain text is like watching paint dry in grayscale

vim.wo.number = true       -- Line numbers (essential for debugging and blame games)
vim.wo.cursorline = true   -- Highlight current line (spotlight on your current mistake)
vim.o.ruler = true         -- Show cursor position (GPS for your code navigation)
vim.o.showcmd = true       -- Display incomplete commands (progress bars for the impatient)
vim.o.termguicolors = true -- 24-bit color support (because 256 colors aren't enough anymore)

-- ┌─────────────────────────────────────────────────────────────────────────────┐
-- │ ENCODING & COMPATIBILITY - Universal Understanding                          │
-- └─────────────────────────────────────────────────────────────────────────────┘
-- UTF-8 because we live in a civilized society with international characters

vim.o.encoding = 'utf-8'   -- Character encoding (supporting emoji in comments since 2023)

-- ┌─────────────────────────────────────────────────────────────────────────────┐
-- │ MOUSE SUPPORT - For Those Who Haven't Fully Evolved                        │
-- └─────────────────────────────────────────────────────────────────────────────┘
-- Controversial but practical (like pineapple on pizza)

vim.o.mouse = 'a'          -- Enable mouse in all modes (bridging the GUI-CLI divide)

-- ┌─────────────────────────────────────────────────────────────────────────────┐
-- │ SEARCH CONFIGURATION - Finding Needles in Code Haystacks                   │
-- └─────────────────────────────────────────────────────────────────────────────┘
-- Advanced search capabilities for the perpetually lost

vim.o.hlsearch = true      -- Highlight search matches (visual confirmation of your queries)
vim.o.incsearch = true     -- Incremental search (live preview as you type)
vim.o.ignorecase = true    -- Case-insensitive search by default
vim.o.smartcase = true     -- Case-sensitive when uppercase letters are used (best of both worlds)

-- ┌─────────────────────────────────────────────────────────────────────────────┐
-- │ SYNTAX & COLORSCHEME - Making Code Beautiful                               │
-- └─────────────────────────────────────────────────────────────────────────────┘
-- Visual appeal matters (even for terminal dwellers)

vim.cmd('syntax on')                    -- Enable syntax highlighting (color-coding for humans)
vim.cmd('colorscheme everforest')       -- Everforest theme (easy on the eyes, hard on bugs)

-- ┌─────────────────────────────────────────────────────────────────────────────┐
-- │ ALE LINTER CONFIGURATION - The Code Quality Enforcer                       │
-- └─────────────────────────────────────────────────────────────────────────────┘
-- Automated nitpicking so you don't have to rely on human code reviewers

-- Language-specific linters (the quality assurance department)
vim.g.ale_linters = {
  c = {'gcc', 'clang', 'cppcheck', 'clangtidy'},     -- C linting arsenal
  cpp = {'g++', 'clang', 'cppcheck', 'clangtidy'}    -- C++ linting toolkit
}

-- Auto-fixers for common formatting issues (automated janitors for your code)
vim.g.ale_fixers = {
  c = {'clang-format'},      -- C formatting automation
  cpp = {'clang-format'}     -- C++ style enforcement
}

-- Linter-specific configurations (fine-tuning the criticism engine)
vim.g.ale_c_cpp_clangtidy_options = '-checks=*,-clang-analyzer-alpha*'  -- Comprehensive but not experimental
vim.g.ale_c_cpp_cppcheck_options = '--enable=all'                       -- Maximum paranoia mode

-- Visual indicators for problems (because subtlety is overrated)
vim.g.ale_sign_error = '✗'        -- Error marker (red flag for serious problems)
vim.g.ale_sign_warning = '⚠'      -- Warning marker (yellow flag for suspicious code)

-- Display options for maximum developer guilt
vim.g.ale_virtualtext_cursor = 1                              -- Inline error messages
vim.g.ale_echo_msg_format = '[%linter%] %s [%severity%]'      -- Detailed error information
vim.g.ale_completion_enabled = 0                             -- Disable ALE completion (we have better tools)
vim.g.ale_set_balloons = 0                                   -- Disable tooltip balloons (less visual noise)

-- ┌─────────────────────────────────────────────────────────────────────────────┐
-- │ COMPLETION BEHAVIOR - Autocomplete Without the Annoyance                   │
-- └─────────────────────────────────────────────────────────────────────────────┘
-- Intelligent suggestions without the popup spam

-- Refined completion options (helpful suggestions without aggressive interruptions)
vim.o.completeopt = 'menu,menuone,noselect'  -- Show menu, even for single match, don't auto-select

-- Legacy commented configuration (archaeological evidence of previous attempts)
-- These were disabled because sometimes less is more in the completion world
--vim.o.completeopt = vim.o.completeopt:gsub('preview', '')
--vim.o.completeopt = vim.o.completeopt:gsub('menu', '')
--vim.o.completeopt = vim.o.completeopt:gsub('menuone', '')
--vim.o.completeopt = vim.o.completeopt:gsub('longest', '')
