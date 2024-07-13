return {
  {
    'windwp/nvim-ts-autotag',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      require('nvim-ts-autotag').setup({
        aliases = {
          ["typescript"] = "html",
          ["javascript"] = "html",
        }
      })
    end
  },
}
