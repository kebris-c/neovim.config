-- ═══════════════════════════════════════════════════════════════════════════════
-- NEOVIM CONFIGURATION BOOTSTRAP
-- ═══════════════════════════════════════════════════════════════════════════════
-- Main entry point for the entire Neovim configuration ecosystem
-- Loading order matters more than your morning coffee routine

-- Ensure packer is available before attempting world domination
vim.cmd [[packadd packer.nvim]]

-- Core configuration modules in order of importance
-- (like a symphony, but with more syntax errors)
require('config.plugins')   -- Plugin management - the foundation of modern civilization
require("config.options")  -- Editor behavior settings - making Neovim behave like a civilized editor
require("config.keymaps")  -- Custom key mappings - because default keys are for peasants
require("tools.valgrind")  -- Memory debugging utilities - catching leaks like a plumber with OCD
