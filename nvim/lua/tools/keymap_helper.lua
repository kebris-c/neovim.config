local M = {}

-- Because life's too short for boring regex patterns
local KEYMAP_PATTERNS = {
    "vim%.keymap%.set",
    "vim%.api%.nvim_set_keymap", 
    "keymap%.set",
    "map%s*%(", -- your original pattern, respected as archaeological relic
    "nmap%s*%(", "imap%s*%(", "vmap%s*%(", "tmap%s*%(", -- because diversity matters
}

-- Colors because life without colors is like Netflix without good series
local HIGHLIGHT_GROUPS = {
    title = "Title",
    border = "FloatBorder", 
    normal = "Normal",
    keymap = "Function",
    line_number = "LineNr",
    description = "Comment"
}

function M.show_custom_keymaps()
    local keymaps_file = vim.fn.expand("~/.config/nvim/lua/config/keymaps.lua")
    
    -- Check if file exists (because Murphy's Law never rests)
    if vim.fn.filereadable(keymaps_file) == 0 then
        vim.api.nvim_err_writeln("Keymap file not found. Do you use keys telepathically?")
        return
    end

    local results = M.parse_keymaps(keymaps_file)
    
    if #results == 0 then
        vim.notify("No keymaps found. Are you a vanilla Vim purist?", vim.log.levels.WARN)
        return
    end

    M.create_popup(results)
end

function M.parse_keymaps(file_path)
    local lines = {}
    local results = {}
    
    -- Read file line by line (like in the old days)
    for line in io.lines(file_path) do
        table.insert(lines, line)
    end
    
    for i, line in ipairs(lines) do
        for _, pattern in ipairs(KEYMAP_PATTERNS) do
            if line:match(pattern) then
                -- Extract useful information from keymap
                local formatted_line = M.format_keymap_line(line, i)
                table.insert(results, formatted_line)
                break -- Because efficiency is sexy
            end
        end
    end
    
    return results
end

function M.format_keymap_line(line, line_number)
    -- Clean tabs and excessive spaces (because minimalism is trendy)
    local clean_line = line:gsub("^%s+", ""):gsub("%s+", " ")
    
    -- Try to extract keymap and description if exists
    local key_pattern = [["([^"]+)"|'([^']+)']]
    local keys = {}
    for key in clean_line:gmatch(key_pattern) do
        if key ~= "" then table.insert(keys, key) end
    end
    
    local display_line = string.format("%3d: %s", line_number, clean_line)
    
    -- If we found keys, make it more readable
    if #keys >= 2 then
        local keymap = keys[1] or "<?>"
        local command = keys[2] or "<?>" 
        local desc = clean_line:match('desc%s*=%s*["\']([^"\']+)["\']') or ""
        
        if desc ~= "" then
            display_line = string.format("%3d: [%s] → %s | %s", line_number, keymap, command, desc)
        else
            display_line = string.format("%3d: [%s] → %s", line_number, keymap, command)
        end
    end
    
    return display_line
end

function M.create_popup(results)
    -- Create temporary buffer (more temporary than TikTok trends)
    local buf = vim.api.nvim_create_buf(false, true)
    
    -- Prepare content with elegant header
    local content = {
        "┌─ Custom Keymaps ─────────────────────────────────────┐",
        "│ Press 'q' or <ESC> to close | 'r' to refresh         │",
        "└──────────────────────────────────────────────────────┘",
        ""
    }
    
    -- Add found keymaps
    for _, line in ipairs(results) do
        table.insert(content, line)
    end
    
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, content)
    vim.api.nvim_buf_set_option(buf, 'modifiable', false)
    vim.api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')
    vim.api.nvim_buf_set_option(buf, 'filetype', 'keymaps')
    
    -- Calculate dimensions like an obsessive-compulsive architect
    local width = 0
    for _, line in ipairs(content) do
        width = math.max(width, vim.fn.strwidth(line))
    end
    width = math.min(width + 4, math.floor(vim.o.columns * 0.9))
    local height = math.min(#content + 2, math.floor(vim.o.lines * 0.8))
    
    local opts = {
        relative = 'editor',
        width = width,
        height = height,
        row = math.floor((vim.o.lines - height) / 2),
        col = math.floor((vim.o.columns - width) / 2),
        style = 'minimal',
        border = 'rounded',
        title = " 🗝️  Keymap Viewer ",
        title_pos = "center"
    }
    
    local win = vim.api.nvim_open_win(buf, true, opts)
    
    -- Setup highlights because colors feed the soul
    M.setup_highlights(buf)
    
    -- Keymaps for popup (meta-level irony)
    local close_cmd = string.format('<cmd>lua vim.api.nvim_win_close(%d, true)<CR>', win)
    local refresh_cmd = '<cmd>lua require("keymap-viewer").show_custom_keymaps()<CR>' .. close_cmd
    
    vim.api.nvim_buf_set_keymap(buf, 'n', 'q', close_cmd, { nowait = true, noremap = true, silent = true })
    vim.api.nvim_buf_set_keymap(buf, 'n', '<ESC>', close_cmd, { nowait = true, noremap = true, silent = true })
    vim.api.nvim_buf_set_keymap(buf, 'n', 'r', refresh_cmd, { nowait = true, noremap = true, silent = true })
    
    -- Auto-close after 30 seconds (because attention is limited)
    vim.defer_fn(function()
        if vim.api.nvim_win_is_valid(win) then
            vim.api.nvim_win_close(win, true)
        end
    end, 30000)
end

function M.setup_highlights(buf)
    -- Basic highlighting to make the view less depressing
    vim.api.nvim_buf_add_highlight(buf, -1, HIGHLIGHT_GROUPS.title, 0, 0, -1)
    vim.api.nvim_buf_add_highlight(buf, -1, HIGHLIGHT_GROUPS.border, 1, 0, -1)
    vim.api.nvim_buf_add_highlight(buf, -1, HIGHLIGHT_GROUPS.border, 2, 0, -1)
    
    -- Highlight for line numbers
    local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
    for i, line in ipairs(lines) do
        if line:match("^%s*%d+:") then
            local num_end = line:find(":") or 0
            vim.api.nvim_buf_add_highlight(buf, -1, HIGHLIGHT_GROUPS.line_number, i-1, 0, num_end)
        end
    end
end

-- Command for easier usage
vim.api.nvim_create_user_command('ShowKeymaps', function()
    M.show_custom_keymaps()
end, { desc = "Show custom keymaps in a fancy popup" })

-- Because a keymap to show keymaps is the ultimate recursion
vim.keymap.set('n', '<leader>sk', M.show_custom_keymaps, { 
    desc = "Show custom keymaps (meta-level activated)" 
})

return M
