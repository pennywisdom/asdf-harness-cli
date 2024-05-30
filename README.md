<div align="center">

# asdf-harness-cli [![Build](https://github.com/pennywisdom/asdf-harness-cli/actions/workflows/build.yml/badge.svg)](https://github.com/pennywisdom/asdf-harness-cli/actions/workflows/build.yml) [![Lint](https://github.com/pennywisdom/asdf-harness-cli/actions/workflows/lint.yml/badge.svg)](https://github.com/pennywisdom/asdf-harness-cli/actions/workflows/lint.yml)

[harness-cli](https://developer.harness.io/docs/category/cli) plugin for the [asdf version manager](https://asdf-vm.com).

</div>

# Contents

- [Dependencies](#dependencies)
- [Install](#install)
- [Contributing](#contributing)
- [License](#license)

# Dependencies

**TODO: adapt this section**

- `bash`, `curl`, `tar`, and [POSIX utilities](https://pubs.opengroup.org/onlinepubs/9699919799/idx/utilities.html).
- `SOME_ENV_VAR`: set this environment variable in your shell config to load the correct version of tool x.

# Install

Plugin:

```shell
asdf plugin add harness-cli
# or
asdf plugin add harness-cli https://github.com/pennywisdom/asdf-harness-cli.git
```

harness-cli:

```shell
# Show all installable versions
asdf list-all harness-cli

# Install specific version
asdf install harness-cli latest

# Set a version globally (on your ~/.tool-versions file)
asdf global harness-cli latest

# Now harness-cli commands are available
harness --version
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install & manage versions.

# Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/pennywisdom/asdf-harness-cli/graphs/contributors)!

# License

See [LICENSE](LICENSE) © [pennywisdom](https://github.com/pennywisdom/)
