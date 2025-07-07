# Currently configuring a nixOS server to install Bonfire and Postgres DB, these files contain current status.

## 07.07/25 - 

From /etc/nixos run `nixos-rebuild switch --flake .#nixos-vm`

see error

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
If you do not need bonfire, comment it out from your configuration and rebuild. This will let you continue using NixOS without this error.
If you do need bonfire, you will need to patch the Nix expression or wait for an upstream fix.
Report the bug:
Report this issue to the maintainers of the bonfire package or to the NixOS/nixpkgs repository. Include the error message and stack trace you provided here.
