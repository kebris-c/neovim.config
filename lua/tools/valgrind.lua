local M = {}

-- Run valgrind on ./a.out
function M.run_valgrind()
	vim.cmd("!valgrind --leak-check=full --track-origins=yes --show-leak-kinds=all ./a.out")
end

-- Clean highlight
function M.clear_highlights()
  local ns_id = vim.api.nvim_create_namespace("valgrind_ns")
  vim.api.nvim_buf_clear_namespace(0, ns_id, 0, -1)
  print("🧹 Valgrind highlights cleared")
end

-- Placeholder highlight function
function M.highlight_errors()
	local handle = io.popen("valgrind --leak-check=full --track-origins=yes --show-leak-kinds=all ./a.out 2>&1")
	if not handle then
		print("Error: Fail executing valgrind")
		return
	end

	local output = handle:read("*a")
	handle:close()

	local current_file = vim.fn.expand("%:t")
	local ns_id = vim.api.nvim_create_namespace("valgrind_ns")
	local leaks_found = false

	-- Cleaning old marked lines
	vim.api.nvim_buf_clear_namespace(0, ns_id, 0, -1)

	for file, line in output:gmatch("%(([%w%._/-]+):(%d+)%)") do
		if file == current_file then
			vim.api.nvim_buf_add_highlight(0, ns_id, "ErrorMsg", tonumber(line) - 1, 0, -1)
			leaks_found = true
		end
	end

	if leaks_found then
		print("💥 Leaks marked in current buffer: " .. current_file)
	else
		print("✅ No leaks detected or not in this buffer.")
	end
end

return M
