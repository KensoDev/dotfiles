local tb   = require('telescope.builtin')
local opts = { noremap = true, silent = true }

vim.keymap.set('n', '<leader>.',  tb.git_files,                           vim.tbl_extend('force', opts, { desc = 'Telescope: Git files' }))
vim.keymap.set('n', '<leader>ff', function() tb.find_files({ hidden=true }) end, vim.tbl_extend('force', opts, { desc = 'Telescope: Find files (hidden)' }))
vim.keymap.set('n', '<leader>fl', tb.live_grep,                           vim.tbl_extend('force', opts, { desc = 'Telescope: Live grep' }))
vim.keymap.set('n', '<leader>fb', tb.buffers,                             vim.tbl_extend('force', opts, { desc = 'Telescope: Buffers' }))
vim.keymap.set('n', '<leader>fh', tb.help_tags,                           vim.tbl_extend('force', opts, { desc = 'Telescope: Help tags' }))
vim.keymap.set('n', '<leader>fd', tb.diagnostics,                         vim.tbl_extend('force', opts, { desc = 'Telescope: Diagnostics' }))
vim.keymap.set('n', '<leader>fr', tb.registers,                           vim.tbl_extend('force', opts, { desc = 'Telescope: Registers' }))

-- LSP note: lsp_code_actions was removed; use the LSP API:
vim.keymap.set({'n','v'}, '<leader>lsa', vim.lsp.buf.code_action,         vim.tbl_extend('force', opts, { desc = 'LSP: Code actions' }))
vim.keymap.set('n', '<leader>lsd', tb.lsp_definitions,                    vim.tbl_extend('force', opts, { desc = 'LSP: Definitions' }))
vim.keymap.set('n', '<leader>lsi', tb.lsp_implementations,                vim.tbl_extend('force', opts, { desc = 'LSP: Implementations' }))
vim.keymap.set('n', '<leader>lst', tb.lsp_type_definitions,               vim.tbl_extend('force', opts, { desc = 'LSP: Type definitions' }))
