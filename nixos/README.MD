# Currently configuring a nixOS server to install Bonfire and Postgres DB, these files contain current status.

## 07.07/25

- Moved `configuration.nix` to `configuration.nix.old`
- Installed SSH Remote in Cursor to connect to remote VM
- Installed Node temporarily on server using `nix-env` as this was a dependancy for using cursor
- Generated flake.nix using a combo of Cursor and https://github.com/bonfire-networks/bonfire-nix/blob/main/flake.nix
-  From /etc/nixos run `nixos-rebuild switch --flake .#nixos-vm`

encounter error

```
error: undefined variable 'ex_aws'
at /nix/store/kicr1x2l25d59qhj5kxn4xpxap9viwar-source/deps.nix:541:20:
540|
541|       beamDeps = [ ex_aws sweet_xml ];
           |                    ^
542|     };
```

The error is in the bonfire package's dependency definition, specifically in deps.nix, where it tries to use ex_aws but that variable is not defined.
The relevant line is:

`beamDeps = [ ex_aws sweet_xml ];`

but ex_aws is not defined anywhere in that scope.

What this means:
This is a packaging bug in the bonfire or ex_aws_s3 Nix expression, not in your own configuration.
The error is not caused by your configuration.nix or flake.nix, but by the upstream Nix expression for bonfire or one of its dependencies.

What you can do:

Workaround:
patch the Nix expression or wait for an upstream fix.
Report the bug:
Report this issue to the maintainers of the bonfire package or to the NixOS/nixpkgs repository. Include the error message and stack trace you provided here.
