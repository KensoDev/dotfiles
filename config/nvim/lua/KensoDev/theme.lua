local function setup_theme()
  -- Theme settings for Dracula
  require("dracula").setup({
    -- Show the '~' characters after the end of buffers
    show_end_of_buffer = true,
    -- Use transparent background
    transparent_bg = true,
    -- Set custom lualine background color
    lualine_bg_color = "#44475a",
    -- Set italic comment
    italic_comment = true,
    -- Overrides the default highlights
    overrides = {
      -- LSP virtual text styling
      DiagnosticVirtualTextError = { italic = true },
      DiagnosticVirtualTextWarn = { italic = true },
      DiagnosticVirtualTextInfo = { italic = true },
      DiagnosticVirtualTextHint = { italic = true },
      -- LSP underline styling
      DiagnosticUnderlineError = { underline = true },
      DiagnosticUnderlineWarn = { underline = true },
      DiagnosticUnderlineInfo = { underline = true },
      DiagnosticUnderlineHint = { underline = true },
    },
  })

  vim.cmd [[colorscheme dracula]]
end

local function init()
  setup_theme()
end

return {
  init = init,
}
