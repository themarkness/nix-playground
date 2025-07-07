{ config, pkgs, bonfire-app, ... }:

{
  imports =
    [
    ./hardware-configuration.nix
    ];
 
  nix.settings.experimental-features =["nix-command" "flakes"];
  
  time.timeZone = "europe/london";
 
  boot = {
   kernelPackages = pkgs.linuxPackages_6_1;
   supportedFilesystems = [ "btrfs"];

  loader.grub = {
  enable = true;
  version = 2;
  forceInstall = true;
  device = "/dev/sda";
  };
 };
 
 networking = {
  hostName = "nixos-vm";
  useDHCP = false;

  interfaces = {
   eth0.useDHCP = true;
 };

 firewall = {
  enable = true;
  allowedTCPPorts =[];
  allowedUDPPorts =[];
  };
 };

 nix = {
    gc = {
      automatic = true;
      dates = "monthly";
      options = "--delete-older-than 30d";
      };
    };

  environment.systemPackages = with pkgs; [
    git
    vim
    bonfire-app.packages.${pkgs.system}.default
  ];

  services.openssh = {
    enable = true;
    permitRootLogin = "yes";
    passwordAuthentication = false;
  };

  services.fail2ban.enable = true;

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 <ssh-key-here>"
  ];

  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_15;
    ensureDatabases = [ "bonfire" ];
    ensureUsers = [
      {
        name = "bonfire";
      }
    ];
    authentication = ''
      local   all             all                                     md5
      host    all             all             127.0.0.1/32            md5
      host    all             all             ::1/128                 md5
    '';
  };

  systemd.services.bonfire = {
    description = "Bonfire federated social app";
    after = [ "network.target" "postgresql.service" ];
    wantedBy = [ "multi-user.target" ];
    environment = {
      DATABASE_URL = "postgresql://bonfire:bonfirepassword@localhost/bonfire";
    };
    serviceConfig = {
      ExecStart = "${bonfire-app.packages.${pkgs.system}.default}/bin/bonfire";
      Restart = "always";
      User = "bonfire";
      WorkingDirectory = "/var/lib/bonfire";
    };
    preStart = ''
      mkdir -p /var/lib/bonfire
      chown bonfire:bonfire /var/lib/bonfire
    '';
  };

  users.users.bonfire = {
    isSystemUser = true;
    home = "/var/lib/bonfire";
    createHome = true;
    group = "bonfire";
  };
  users.groups.bonfire = {};

  system.stateVersion = "23.11";
}
