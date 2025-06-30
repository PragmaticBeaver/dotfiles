# found this inside a NixOS GitHub descussion
# =====================================================================================================
# I found a post about [suspending and then going into hibernate](http://askubuntu.com/a/33192) 
# that included a really clever script.  
# Turns out that with NixOS this is even esaier to coordinate 
# as you have systemd so can have a `before` and `after` service.
# I just include this in my `/etc/nixos/configuration.nix` file and `nixos-rebuild`;
# then a `systemctl suspend` or a close of the lid will cause the hibernate timer to be set.
# =====================================================================================================

{ config, pkgs, ... }: let
  hibernateEnvironment = {
    HIBERNATE_SECONDS = "1800";
    HIBERNATE_LOCK = "/var/run/autohibernate.lock";
  };
in {
  systemd.services."awake-after-suspend-for-a-time" = {
    description = "Sets up the suspend so that it'll wake for hibernation";
    wantedBy = [ "suspend.target" ];
    before = [ "systemd-suspend.service" ];
    environment = hibernateEnvironment;
    script = ''
      curtime=$(date +%s)
      echo "$curtime $1" >> /tmp/autohibernate.log
      echo "$curtime" > $HIBERNATE_LOCK
      ${pkgs.utillinux}/bin/rtcwake -m no -s $HIBERNATE_SECONDS
    '';
    serviceConfig.Type = "simple";
  };
  systemd.services."hibernate-after-recovery" = {
    description = "Hibernates after a suspend recovery due to timeout";
    wantedBy = [ "suspend.target" ];
    after = [ "systemd-suspend.service" ];
    environment = hibernateEnvironment;
    script = ''
      curtime=$(date +%s)
      sustime=$(cat $HIBERNATE_LOCK)
      rm $HIBERNATE_LOCK
      if [ $(($curtime - $sustime)) -ge $HIBERNATE_SECONDS ] ; then
        systemctl hibernate
      else
        ${pkgs.utillinux}/bin/rtcwake -m no -s 1
      fi
    '';
    serviceConfig.Type = "simple";
  };
}