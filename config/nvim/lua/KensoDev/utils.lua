local M = {}

M.WinMove = function(command_key)
    local curwin = vim.api.nvim_get_current_win()

    vim.cmd(string.format("wincmd %s", command_key))

    if curwin == vim.api.nvim_get_current_win() then
        if command_key:match("[jk]") then
            vim.cmd("wincmd v")
        else
            vim.cmd("wincmd s")
        end

        vim.cmd(string.format("wincmd %s", command_key))
    end
end

return M
