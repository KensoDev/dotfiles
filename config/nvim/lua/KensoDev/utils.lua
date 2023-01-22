local M = {}

M.WinMove = function(command_key)
    local curwin = vim.api.nvim_get_current_win()

    vim.cmd(string.format("wincmd %s", command_key))
    local newwin = vim.api.nvim_get_current_win()

    if curwin == newwin then
        if command_key:match("[jk]") then
            vim.cmd("wincmd s")
        else
            vim.cmd("wincmd v")
        end

        vim.cmd(string.format("wincmd %s", command_key))
    end
end

return M
