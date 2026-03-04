
local function setup_extras()
  require("gitsigns").setup({
    on_attach = function(bufnr)
      local gs = package.loaded.gitsigns

      -- Git blame keybindings
      vim.keymap.set('n', '<leader>gb', gs.blame_line, {buffer = bufnr, desc = 'Git blame line'})
      vim.keymap.set('n', '<leader>gB', function() gs.blame_line{full=true} end, {buffer = bufnr, desc = 'Git blame (full)'})
      vim.keymap.set('n', '<leader>tb', gs.toggle_current_line_blame, {buffer = bufnr, desc = 'Toggle inline blame'})

      -- Hunk navigation
      vim.keymap.set('n', ']c', function()
        if vim.wo.diff then return ']c' end
        vim.schedule(function() gs.next_hunk() end)
        return '<Ignore>'
      end, {expr=true, buffer = bufnr, desc = 'Next hunk'})

      vim.keymap.set('n', '[c', function()
        if vim.wo.diff then return '[c' end
        vim.schedule(function() gs.prev_hunk() end)
        return '<Ignore>'
      end, {expr=true, buffer = bufnr, desc = 'Prev hunk'})
    end
  })

  require("lsp-colors").setup()

  require("lsp_lines").setup()

  require("lualine").setup({
    options = {
      extensions = { "fzf", "quickfix" },
      theme = "catppuccin"
    }
  })

  vim.diagnostic.config({
    virtual_text = false,
  })
end

local function init()
  setup_extras()
end

return {
  init = init,
}
