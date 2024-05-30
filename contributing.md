# Contributing

Testing Locally:

```shell
asdf plugin test <plugin-name> <plugin-url> [--asdf-tool-version <version>] [--asdf-plugin-gitref <git-ref>] [test-command*]
e.g.:
asdf plugin test harness-cli https://github.com/pennywisdom/asdf-harness-cli.git "harness --version"
```

Tests are automatically run in GitHub Actions on push and PR.
