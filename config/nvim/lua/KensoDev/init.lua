local function init()
  require 'KensoDev.vim'.init()
  require 'KensoDev.theme'.init()
  require 'KensoDev.languages'.init()
  require 'KensoDev.treesitter'.init()
  require 'KensoDev.completion'.init()
  require 'KensoDev.telescope'.init()
  require 'KensoDev.floaterm'.init()
  require 'KensoDev.extras'.init()
end

return {
  init = init,
}
