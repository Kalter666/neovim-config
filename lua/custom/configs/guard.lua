local guard = require('guard')
local ft = require('guard.filetype')


ft('typescript,javascript,typescriptreact,markdown,html,css')
  :fmt('prettier')
  :lint('eslint_d')

ft('lua'):fmt('lsp')
        :append('stylua')
        :lint('selene')

ft('go'):fmt('gofmt');

ft('rust'):fmt('rustfmt');


return guard
