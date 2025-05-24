local M = {}

-- Configuration table - because hardcoding paths is for people who enjoy debugging at 3 AM
local config = {
    executable = "./a.out",
    valgrind_args = "--leak-check=full --track-origins=yes --show-leak-kinds=all",
    namespace = "valgrind_ns",
    highlight_group = "ErrorMsg",
    timeout = 30000, -- 30 seconds, because infinite loops are for infinite pain
}

-- Setup function - lets users configure this beast without diving into source code
function M.setup(opts)
    if opts then
        config = vim.tbl_deep_extend("force", config, opts)
    end
end

-- Validate executable exists - because assuming files exist is like assuming your code works on first try
local function validate_executable(exec_path)
    local handle = io.popen("test -f " .. vim.fn.shellescape(exec_path) .. " && echo 'exists'")
    if not handle then
        return false, "Failed to check executable existence"
    end
    
    local result = handle:read("*a")
    handle:close()
    
    if result:match("exists") then
        return true
    else
        return false, "Executable '" .. exec_path .. "' not found. Did you forget to compile?"
    end
end

-- Check if valgrind is available - because not everyone lives in the same dev environment bubble
local function check_valgrind_available()
    local handle = io.popen("which valgrind 2>/dev/null")
    if not handle then
        return false
    end
    
    local result = handle:read("*a")
    handle:close()
    
    return result ~= ""
end

-- Run valgrind interactively - for when you want to see the carnage in real-time
function M.run_valgrind(exec_path)
    exec_path = exec_path or config.executable
    
    if not check_valgrind_available() then
        print("❌ Valgrind not found. Install it or accept your memory leaks with dignity.")
        return
    end
    
    local valid, err = validate_executable(exec_path)
    if not valid then
        print("❌ " .. err)
        return
    end
    
    local cmd = string.format("valgrind %s %s", config.valgrind_args, vim.fn.shellescape(exec_path))
    vim.cmd("!" .. cmd)
end

-- Clear all valgrind highlights - because sometimes you need a clean slate
function M.clear_highlights()
    local ns_id = vim.api.nvim_create_namespace(config.namespace)
    vim.api.nvim_buf_clear_namespace(0, ns_id, 0, -1)
    print("🧹 Valgrind highlights cleared. Your buffer is now pristine and judgment-free.")
end

-- Parse valgrind output with more sophistication than a regex from 1995
local function parse_valgrind_output(output)
    local errors = {}
    local current_file = vim.fn.expand("%:p") -- Full path for better matching
    local current_file_name = vim.fn.expand("%:t") -- Just filename as fallback
    
    -- Pattern matching for various valgrind output formats
    -- Because valgrind is about as consistent as a cryptocurrency's value
    local patterns = {
        "==.+==%s+at .+%((.+):(%d+)%)", -- Standard format
        "==.+==%s+by .+%((.+):(%d+)%)", -- Stack trace format
        "%s*at .+%((.+):(%d+)%)", -- Sometimes valgrind drops the PID prefix
        "%s*by .+%((.+):(%d+)%)" -- Stack trace without PID
    }
    
    for line in output:gmatch("[^\r\n]+") do
        for _, pattern in ipairs(patterns) do
            local file, line_num = line:match(pattern)
            if file and line_num then
                -- Check if this error is in our current file
                if file == current_file or file == current_file_name or file:match(current_file_name .. "$") then
                    local num = tonumber(line_num)
                    if num and num > 0 then
                        table.insert(errors, {
                            file = file,
                            line = num,
                            raw_line = line:gsub("^==.+==%s*", "") -- Clean up the line for display
                        })
                    end
                end
            end
        end
    end
    
    return errors
end

-- Show error details in a floating window - because debugging deserves style
local function show_error_popup(errors)
    if #errors == 0 then
        return
    end
    
    local lines = {"Valgrind Errors in Current File:", ""}
    for i, error in ipairs(errors) do
        table.insert(lines, string.format("%d. Line %d: %s", i, error.line, error.raw_line))
    end
    
    -- Create floating window with errors
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    
    local width = math.min(80, vim.o.columns - 4)
    local height = math.min(#lines + 2, vim.o.lines - 4)
    
    local opts = {
        relative = 'editor',
        width = width,
        height = height,
        col = (vim.o.columns - width) / 2,
        row = (vim.o.lines - height) / 2,
        style = 'minimal',
        border = 'rounded',
        title = ' Valgrind Report ',
        title_pos = 'center'
    }
    
    vim.api.nvim_open_win(buf, true, opts)
    
    -- Make it easier to close
    vim.api.nvim_buf_set_keymap(buf, 'n', 'q', '<cmd>close<CR>', {noremap = true, silent = true})
    vim.api.nvim_buf_set_keymap(buf, 'n', '<Esc>', '<cmd>close<CR>', {noremap = true, silent = true})
end

-- Main highlight function - now with 200% more reliability and 50% fewer crashes
function M.highlight_errors(exec_path, show_popup)
    exec_path = exec_path or config.executable
    show_popup = show_popup ~= false -- Default to true
    
    if not check_valgrind_available() then
        print("❌ Valgrind not found. This is like trying to debug without printf statements.")
        return
    end
    
    local valid, err = validate_executable(exec_path)
    if not valid then
        print("❌ " .. err)
        return
    end
    
    print("🔍 Running Valgrind analysis... (this might take a moment, like waiting for CI to pass)")
    
    local cmd = string.format("timeout %d valgrind %s %s 2>&1", 
                             config.timeout / 1000, 
                             config.valgrind_args, 
                             vim.fn.shellescape(exec_path))
    
    local handle = io.popen(cmd)
    if not handle then
        print("❌ Failed to execute Valgrind. Even the memory checker is out of memory.")
        return
    end
    
    local output = handle:read("*a")
    local success, _, exit_code = handle:close()
    
    -- Valgrind returns non-zero when it finds issues, which is expected
    if exit_code == 124 then -- timeout exit code
        print("⏰ Valgrind timed out. Your program might be stuck in an infinite loop of regret.")
        return
    end
    
    local errors = parse_valgrind_output(output)
    local ns_id = vim.api.nvim_create_namespace(config.namespace)
    
    -- Clear old highlights
    vim.api.nvim_buf_clear_namespace(0, ns_id, 0, -1)
    
    if #errors > 0 then
        -- Highlight error lines
        local highlighted_lines = {}
        for _, error in ipairs(errors) do
            local line_num = error.line - 1 -- Vim uses 0-based indexing because consistency is overrated
            if not highlighted_lines[line_num] then
                vim.api.nvim_buf_add_highlight(0, ns_id, config.highlight_group, line_num, 0, -1)
                highlighted_lines[line_num] = true
            end
        end
        
        print(string.format("💥 Found %d error(s) in current buffer. Time to face the music.", #errors))
        
        if show_popup then
            show_error_popup(errors)
        end
    else
        -- Check if valgrind actually ran and found no errors, or if there were no relevant errors
        if output:match("ERROR SUMMARY: 0 errors") then
            print("✅ No memory errors detected. Your code is cleaner than a fresh install of Ubuntu.")
        else
            print("🤷 No errors found in current buffer, but check the full Valgrind output to be sure.")
        end
    end
end

-- Quick command to run and highlight in one go - because developers love shortcuts
function M.analyze(exec_path)
    M.highlight_errors(exec_path, true)
end

-- Get current configuration - for debugging the debugger
function M.get_config()
    return vim.deepcopy(config)
end

-- Set executable path dynamically - because flexibility is key
function M.set_executable(path)
    config.executable = path
    print("🎯 Executable set to: " .. path)
end

return M

--[[
PROFESSIONAL GRADE IMPROVEMENTS:

✅ Configuration system - No more hardcoded values
✅ Input validation - Because trusting user input is like trusting a used car salesman
✅ Error handling - Proper error messages instead of silent failures
✅ Flexible parsing - Multiple regex patterns for different valgrind formats
✅ Floating window popup - Modern UX for error display
✅ Timeout handling - Because infinite loops are for infinite sadness
✅ Better file matching - Handles relative/absolute paths like a champ
✅ Duplicate prevention - No more highlighting the same line 47 times
✅ Executable validation - Checks if files exist before trying to run them
✅ Valgrind availability check - Because assuming tools exist is optimistic
✅ Clean API - Functions that actually make sense
✅ Documentation - Comments that don't lie about what the code does

USAGE EXAMPLES:
```lua
-- Basic setup
require('valgrind').setup({
    executable = "./my_program",
    timeout = 60000 -- 60 seconds for complex programs
})

-- Quick analysis
require('valgrind').analyze()

-- Just highlight without popup
require('valgrind').highlight_errors("./my_program", false)

-- Clear highlights
require('valgrind').clear_highlights()
```

This is now production-ready code that won't make your team lead question
your life choices. It handles edge cases, provides useful feedback, and
follows proper software engineering practices.

Unlike the original version, this one assumes you might actually want to
use it on projects that aren't named "a.out" - revolutionary concept, I know.
--]]
