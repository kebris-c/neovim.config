-- ═══════════════════════════════════════════════════════════════════════════════
-- PLUGIN MANAGEMENT SYSTEM - The Software Dependency Hell Navigator
-- ═══════════════════════════════════════════════════════════════════════════════
-- Because vanilla Neovim is like a smartphone without apps: technically functional but socially embarrassing

local fn = vim.fn
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
local packer_bootstrap = false

-- ┌─────────────────────────────────────────────────────────────────────────────┐
-- │ PACKER BOOTSTRAP - Automated Plugin Manager Installation                   │
-- └─────────────────────────────────────────────────────────────────────────────┘
-- Self-installing plugin manager (because even plugin managers need plugin managers)

if fn.empty(fn.glob(install_path)) > 0 then
    print("🚀 Packer not found, initiating self-installation sequence...")
    fn.system({
        'git', 'clone', '--depth', '1', 
        'https://github.com/wbthomason/packer.nvim', 
        install_path
    })
    vim.cmd [[packadd packer.nvim]]
    packer_bootstrap = true
    print("✅ Packer successfully acquired. Plugin ecosystem ready for colonization.")
end

-- Force load packer (because sometimes subtle hints aren't enough)
vim.cmd [[packadd packer.nvim]]

-- ┌─────────────────────────────────────────────────────────────────────────────┐
-- │ PLUGIN ECOSYSTEM CONFIGURATION                                              │
-- └─────────────────────────────────────────────────────────────────────────────┘
-- The curated collection of software extensions that make life bearable

return require('packer').startup(function(use)
    -- ┌─────────────────────────────────────────────────────────────────────────┐
    -- │ ESSENTIAL DEVELOPMENT TOOLS - The Survival Kit                         │
    -- └─────────────────────────────────────────────────────────────────────────┘
    
    -- 42 School specific tooling (because institutional compliance is life)
    use 'alexandregv/norminette-vim'  -- Code style enforcer for the academically oppressed
    
    -- Visual themes (because staring at plain text causes existential dread)
    use { 'dracula/vim', as = 'dracula' }  -- Gothic vampire aesthetic for night coding sessions
    use 'sainnhe/everforest'               -- Nature-inspired theme for eco-conscious developers
    
    -- Code quality enforcement (automated criticism for masochistic programmers)
    use 'dense-analysis/ale'               -- Asynchronous linting engine (the perfectionist's nightmare)
    use 'vim-syntastic/syntastic'          -- Syntax checking (legacy support for the traditionalists)
    
    -- File management (for those who refuse to memorize directory structures)
    use 'preservim/nerdtree'               -- File explorer that makes GUI users feel at home
    
    -- Status line enhancement (because default vim status is depressingly minimal)
    use 'vim-airline/vim-airline'          -- Information-rich status bar for data addicts
    
    -- ┌─────────────────────────────────────────────────────────────────────────┐
    -- │ PROFESSIONAL DEBUGGING SUITE - When Printf Isn't Enough                │
    -- └─────────────────────────────────────────────────────────────────────────┘
    -- Advanced debugging tools for developers who've evolved beyond caveman techniques
    
    -- Core Debug Adapter Protocol implementation
    use {
        'mfussenegger/nvim-dap',
        config = function()
            require("tools.dap")  -- Custom DAP configuration loader
        end
    }
    
    -- Debug UI enhancement (making debugging visually appealing since 2021)
    use {
        'rcarriga/nvim-dap-ui',
        requires = { 
            'mfussenegger/nvim-dap',     -- Core debugging functionality
            'nvim-neotest/nvim-nio'      -- Asynchronous IO operations
        },
        config = function()
            local dap, dapui = require("dap"), require("dapui")
            dapui.setup()
            
            -- Automatic UI management (because manual window management is for peasants)
            dap.listeners.after.event_initialized["dapui_config"] = function()
                dapui.open()  -- Show debug UI when session starts
            end
            dap.listeners.before.event_terminated["dapui_config"] = function()
                dapui.close()  -- Hide debug UI when session ends
            end
            dap.listeners.before.event_exited["dapui_config"] = function()
                dapui.close()  -- Cleanup on debug session exit
            end
        end
    }
    
    -- Inline debug information display (virtual text overlay system)
    use {
        'theHamsta/nvim-dap-virtual-text',
        requires = { 'mfussenegger/nvim-dap' },
        config = function()
            require("nvim-dap-virtual-text").setup()  -- Enable inline debug value display
        end
    }
    
    -- ┌─────────────────────────────────────────────────────────────────────────┐
    -- │ POST-INSTALLATION AUTOMATION                                            │
    -- └─────────────────────────────────────────────────────────────────────────┘
    -- Self-maintaining plugin ecosystem (because manual maintenance is for barbarians)
    
    if packer_bootstrap then
        print("🔄 First-time setup detected. Synchronizing plugin universe...")
        require('packer').sync()
        print("🎉 Plugin ecosystem successfully established. Ready for productive procrastination!")
    end
end)
