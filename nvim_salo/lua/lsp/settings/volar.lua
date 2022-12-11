return {
  init_options = {
    typescript = {
      tsdk = '',
    },
  },
  on_new_config = function(new_config, new_root_dir)
    new_config.init_options.typescript.tsdk = get_typescript_lib_path(new_root_dir)
  end,
  capabilities = cmp_capabilities,
  on_attach = on_attach,
  flags = { debounce_text_changes = 150 },
  settings = {
    volar = { autoCompleteRefs = true },
  },
}
