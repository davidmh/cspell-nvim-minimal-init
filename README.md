Minimal configuration for [cspell.vim](https://github.com/davidmh/cspell.nvim)

Install local dependencies, to provide CSpell through the npm modules.

```shell
yarn install
```

Open Neovim using:

```shell
nvim -u minimal-init.lua docs/dev/index.md
```

Keybindings:

- `<space>a` Code action
- `<space>n` Next diagnostic
- `<space>p` Previous diagnostic


Update `minimal-init.lua` and link me to the branch with your use case.
