# Email address completion using goobook

This is a vim plugin to support email address completion by making use of [goobook][1] to query [Google Contacts][2] for managed email addresses.

Note that this plugin is heavily based on the original [gist][3] by Matthew Horan.

## Configuration

For most users, the default configuration should work just fine; however,
global variables can be used to change a few things here and there.

`g:goobookrc` can be used to tell the plugin to invoke `goobook` with a custom
configuration file (i.e. specifying the `-c` flag):

    let g:goobookrc = '~/.goobookrc.account1'

`g:goobookprg` (or it's buffer variant `b:goobookprg`) can instead be used to
tell the plugin to invoke a completely different program than `goobook` (of
course you might want to set this to the name of a program with compatible
output, like [aadbook][4] for querying Azure AD contacts):

    let g:goobookprg = 'aadbook'

## Authors

- Alexander Lehmann <afwlehmann@googlemail.com>
- Matthew Horan <matt@matthoran.com>
- Matteo Landi <matteo@matteolandi.net>

[1]: https://gitlab.com/goobook/goobook
[2]: http://contacts.google.com
[3]: https://gist.github.com/mhoran/1667695
[4]: https://pypi.org/project/aadbook
