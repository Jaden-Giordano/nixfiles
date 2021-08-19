# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      <musnix>
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "freya"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp8s0.useDHCP = true;
  networking.interfaces.enp9s0.useDHCP = true;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # sound.enable = true; Dont need this for pipewire
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    # jack.enable = true;
    #
    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    # media-session.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users = {
    grey = {
      isNormalUser = true;
      extraGroups = [ "wheel" "dialout" "libvirtd" "audio" "input" ]; # Enable ‘sudo’ for the user.
      shell = pkgs.zsh;
    };
    qemu-libvirtd.extraGroups = [ "input" "audio" ];
    windows = {
        isSystemUser = true;
    };
  };

  fonts.fonts = with pkgs; [
    (nerdfonts.override { fonts = ["FiraMono" "FiraCode" "Terminus"]; })
  ];

  # List packages installed in system profile. To search, run:
  nixpkgs.config.allowUnfree = true;  

  environment.systemPackages = with pkgs; [
    ripgrep
    coreutils
    emacs
    fd

    gtk3
    libtool
    clang
    rustup
    cmake
    ninja
    gnumake
    binutils

    vim
    git
    firefox
    home-manager
    discord
    bibata-extra-cursors
    openssl
    ffmpeg-full
    openh264

    libvirt
    virt-manager

    pavucontrol
    pulseaudio
  ];

  programs.dconf.enable = true;
  programs.zsh.enable = true;
  programs.steam.enable = true;
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraPackages = with pkgs; [
      swaylock
      wofi
      alacritty
      # wl-clipboard
      waybar
      autotiling
      flashfocus
      wf-recorder
      slurp
      grim
      v4l-utils
      swayidle
    ];
  };

  virtualisation.libvirtd = {
    enable = true;
    qemuOvmf = true;
    qemuRunAsRoot = true;
    onBoot = "ignore";
    onShutdown = "shutdown";
    qemuVerbatimConfig = ''
      user = "grey"

      cgroup_device_acl = [
        "/dev/null",
        "/dev/full",
        "/dev/zero",
        "/dev/random",
        "/dev/urandom",
        "/dev/kvm",
        "/dev/kqemu",
        "/dev/hpet",
        "/dev/sev",
        "/dev/rtc",
        "/dev/ptmx",
        "/dev/input/by-id/usb-Wings_Tech_Xtrfy_M4-event-mouse",
        "/dev/input/by-id/usb-Dygma_Raise_06933BAD50534B54332E3120FF093211raiseD-if02-event-kbd",
      ]
      namespaces = []
    '';
  };

  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTR{1209}=="24c6", ATTR{2201}=="543a", MODE="0666"
    SUBSYSTEM=="usb", ATTR{2ea8}=="24c6", ATTR{2203}=="543a", MODE="0666"
  '';

  services.printing.enable = true;
  services.printing.drivers = [ pkgs.cnijfilter2 ];

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${lib.makeBinPath [pkgs.greetd.tuigreet] }/tuigreet --time --cmd sway";
        user = "greeter";
      };
    };
  };

  # security.sudo.extraConfig = ''
  #   grey  ALL=(ALL) NOPASSWD: ${pkgs.systemd}/bin/systemctl
  # '';
  # musnix = {
  #   enable = true;
  #   alsaSeq.enable = false;
  #
  #   soundcardPciId = "11:00.4";
  #
  #   rtirq = {
  #     resetAll = 1;
  #     prioLow = 0;
  #     enable = true;
  #     nameList = "rtc0 snd";
  #   };
  # };

  # services.jack = {
  #   jackd.enable = true;
  #   jackd.extraOptions = [ "-dalsa" "--device" "hw:1" ];
  #   alsa.enable = true;
  # };
  # systemd.user.services.pulseaudio.environment = {
  #   JACK_PROMISCUOUS_SERVER = "jackaudio";
  # };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 25565 ];
  networking.firewall.allowedUDPPorts = [ 25565 ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?

}

