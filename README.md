# CadQuery and CQ-editor flake

## What is this

Concepts:

1. [nix package manager](https://nixos.org/guides/nix-pills/why-you-should-give-it-a-try.html) and [the NixOS Linux distribution](https://nixos.org/)
2. [nix flakes](https://www.tweag.io/blog/2020-05-25-flakes/)
3. [CadQuery and CQ-editor](https://cadquery.readthedocs.io/en/latest/intro.html)

This repo is a nix flake that allows you to reproduce a CadQuery and CQ-editor installation anywhere that has nix. Well, a version of nix with flake support, which is currently only in unstable but should be merged soon. Also, it probably won't work outside of NixOS, because graphic drivers are super difficult to make reproducible. But anyway.

This means that you can create a model in CadQuery and note down the commit to this repo you used to build it (or fork it and take control yourself). At any point in the future you can use the same command to run CQ-editor and due to the flake describing all the sources of every package used by CQ-editor it will still work, regardless of:

* changes to the CadQuery API breaking backwards compatibility
* new Python versions
* nixpkgs dropping support for Sphinx ~~2.4~~ 3.0.2 or whatever other version it gets pinned to next
* etc., you get the idea, breaking changes anywhere in the chain of packages.

## Commands

To run CQ-editor:

```sh
nix run github:marcus7070/cq-flake
```

Note that I currently set `QT_QPA_PLATFORM=xcb` in the CQ-editor wrapper. I need to do this to get it to work under Wayland, and I think it should work for most X based window managers as well, but YMMV.

To create an environment with CadQuery and python-language-server (where hopefully your IDE will pick up python-language-server and supply autocomplete, docs, etc.):
```sh
nix shell github:marcus7070/cq-flake#cadquery-env
```

To get the most out of this flake you should specify a commit along with those commands and note it down so you are always using the same CadQuery, eg.
```sh
nix run github:marcus7070/cq-flake/14d05cee591dccf5d64fa0e502e6e381a531c718
```

You can also generate the docs with:
```
nix build github:marcus7070/cq-flake#cadquery-docs
```
which will leave a symlink called `result` pointing to the HTML docs. Note that the [Read The Docs](https://cadquery.readthedocs.io/en/latest/intro.html) version is not frequently updated.

## Build times

`OCP` is a huge build. It takes me about an hour on a beefy desktop. One day I'll get around to publishing my build results to [Cachix](https://cachix.org/) so you can download the binaries directly. Feel free to leave an issue here if you want me to hurry up.

If you build it on one machine, you can push it to other machines with the command
```sh
nix copy --to ssh://192.168.1.XXX /nix/store/xxxxxxx-hashymchashyface-xxxxxxx-cq-editor-local
```

## Local dev

Should you wish to do dev work with CadQuery check out the `dev` branch of this repo. `flake.nix` shows how to reference a local copy (must be a Git repo) of CadQuery instead of a GitHub copy. Then use a command like:

```sh
nix flake update --update-input cadquery . && nix build -L .#cadquery-docs && qutebrowser ./result-doc/share/doc/index.html
```
