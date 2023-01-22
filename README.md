# pre-commit-hooks

A collection of useful [pre-commit](https://pre-commit.com/) hooks.

## check-encoding

A pre-commit hook that checks the encoding of the files. See
[check_encoding.sh](src/sh/check_encoding.sh) for options.

### Limitations

- Needs program `file` installed
- Only tested on Linux (should work on all OS with `sh` and `file`)
