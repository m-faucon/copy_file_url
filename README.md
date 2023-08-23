# copy_file_url.sh

## Use Case

You are in your editor and you want to point a coworker to a specific line.

You want to give them an url of the form `https://github.com/m-faucon/copy_file_url/blob/master/copy_file_url.sh#L17`.

Begin numerous and tiresome seconds, when you need to open a browser tab, navigate to that file in that branch,
scroll down or search to that line, and finally copy from the url bar.

What if you could just instead press a key?

## Usage

``` sh
copy_file_url.sh FILENAME LINE_NUMBER [ALSO_GO]
```

will copy the url you want to your clipboard

If `ALSO_GO` is not null, also open a browser tab (not implemented yet)

Rather than type this in the terminal, this is meant to be bound to a key in your editor

(sample code for popular editors coming shortly. PRs welcome.)

## Requirements

It will try the following copy-to-clipboard utilities until one is found :
- `pbcopy` (installed by default on MacOS)
- `xclip` (generally installed in X11)
- `wl-copy`(on Wayland, provided by the package `wl-clipboard`)
- `clip.exe` (WSL)

I have only tried it on X11, feedback welcome.

## Supported git hosting websites
For now :

- github
- gitlab
- sourcehut

