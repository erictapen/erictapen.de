---
title: Automated IRC with ii on NixOS
---

## Motivation

I'm not a very frequent IRC user and this comes mostly from my dissatisfacion with my current IRC client (a graphical thing with lots of buttons). Quite a while ago I stumbled over [ii](http://tools.suckless.org/ii/), which is as simple as I want it. Unfortunately, I have to handle session initiation by myself so this is how I did it on [NixOS](http://nixos.org/).

## Non-generic solution

For me, IRC communications should be as available as possible. As ii needs not so many resources, I want it to stay online as long as my computer is online. This should be done automatically, so I don't want to start a shell script by hand everytime I want to join channels. Systemd services seemed appropriate to me in this case. My service config for the `#nixos` channel on `irc.freenode.net` looks like this.

 
```nix
systemd.services = {
  "ii-irc.freenode.net = {
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    description = "ii irc.freenode.net";
    script = ''
      ${pkgs.ii}/bin/ii -i ${config.users.users.justin.home}/irc/ -n erictapen -s irc.freenode.net
    '';
    postStart = '' 
      sleep 10s
      echo "/j #${channel}" > ${config.users.users.justin.home}/irc/irc.freenode.net/in
    '';
    serviceConfig = {
      User = "justin";
      Restart = "on-failure";
      RestartSec = "3";
    };
  };
};
```

`systemd.services` is a set of services, which are specified additionaly to the predefined. If you already use it somewhere, you must merge the sets somehow. The service is called `ii-irc.freenode.net` (just a stupid invention from my side). `after` and `wantedBy` make sure, that the service has network access and that it is started automatically as soon as I log in. `ii` itself is not a daemon, so starting and stopping of the service is simply done by starting and terminating a shell command defined in `script`. My `ii` directory is in `/home/justin/irc/`, my username is `erictapen` and the server is `irc.freenode.net`. Joining channels must be done after the connection to the server is established, so I put that into `postStart` with a delay of ten seconds. All communication with `ii` is done with files. Have a look at `ii` documentation if you wonder why I pipe someting into an `in` file in order to join a channel. At last I define, that the service shall be run as user `justin`, as I want to have access rights to the files `ii` creates. First I tried systemd user services, but somehow they did'nt start automatically at login time and I stumbled in some problems with unit files not being reloaded automatically after `nixos-rebuild switch`. `on-failure` means, that the service shall be restarted if its process fails. I know little about systemd but I hope, that restarting is limited to process failure and does not apply to a missing dependency, e.g. when my computer has no network.

## Generic solution

The solution above works, but I need multiple IRC servers and `ii` is not able to connect to more than one server at once. Also I want adding servers and channels to be easy. Nix to the rescue! As I'm already writing my configuration in a functional language, I start throwing my little knowledge about functional programming at the problem.

```nix
systemd.services =
② builtins.listToAttrs (
①   builtins.map
      ({server, channels}:{
        name = "ii-${server}";
        value = {
          after = [ "network.target" ];
          wantedBy = [ "multi-user.target" ];
          description = "ii ${server}";
          script = ''
            ${pkgs.ii}/bin/ii -i ${config.users.users.justin.home}/irc/ -n erictapen -s ${server}
          '';
③         postStart = builtins.concatStringsSep "\n" (
            ["sleep 10s"] ++ map
              (channel:
                "echo \"/j \#${channel}\" > ${config.users.users.justin.home}/irc/${server}/in"
              )
              channels
          );
          serviceConfig = {
            User = "justin";
            Restart = "on-failure";
            RestartSec = "3";
          };
        };
      })
      [
        { server = "irc.freenode.net"; channels = [ "nixos" "tuebix" ]; }
        { server = "irc.hackint.org"; channels = [ "gluon" ]; }
      ]
);
```

Alot of `builtins` functions are used in here. This time I'll use number annotations to explain the code. The order is chosen to make understanding easier.

### ① 

Essentially I'm mapping a function which turns an attribute set into a service definition on a list of attribute sets. Each attribute set consists of a string `server` and `channels`, which is a string list of channel names. An easier example for understanding `builtins.map` would be this:

```nix
builtins.map
  (x:
    x + 1)
  [
    1
    2
    3
  ]
```

`builtins.map` takes a function and a list and applies the function on every list element. The resulting list would be `[ 2 3 4 ]`. 

### ② 

The return value of the function is an attribute set with two elements; a `name` and `value`, where `name` is the service name and `value` is it's definition. As `builtins.map` results in a list, the result would look like this:

```nix
[
  {
    name = "ii-irc.freenode.net";
    value = {
      ...
    };
  }
  {
    name = "ii-irc.hackint.org";
    value = {
      ...
    };
  }
]
```

`systemd.services` expects an attribute set of the form:

```nix
{
  "ii-irc.freenode.net" = {
    ...
  };
  "ii-irc.hackint.org" = {
    ...
  };
}
```

The transformation between the two data structures is done with `builtins.listToAttrs`. Have a look at the [Nix manual](https://nixos.org/nix/manual/#ssec-builtins) for further information on that function.

### ③ 

The `postStart` script should contain a `sleep` of ten seconds, followed by the join commands of all the channels. This is archieved by `builtins.concatStringsSep`, which takes a seperator string and a list of Strings. The list consists of the sleep command plus a map of the channels list on a function, which builds the command. An easier example for that function composition would be

```nix
builtins.concatStringsSep 
  "\n" 
  ([ "init" ] ++ map
      (x:
        "echo " + x 
      )
      [ "there" "is" "no" "such" "thing" "as" "cyberspace" ])
```

resulting in

```plain
init
echo there
echo is
echo no
echo such
echo thing
echo as
echo cyberspace
```

## Modular solution

One could now split the service logic and the configuration in different parts (like it happens in NixOS modules), but I don't see a gain at the moment from hiding the service logic. If this would get some attention and the need for modularization, one could write it in such a way that this could be possible:

```nix
services.ii-fetch = {
  enable = true;
  nickname = "erictapen";
  dir = /home/justin/irc/;
  resources = {
    "irc.freenode.net" = [
      "nixos"
      "tuebix"
    ];
    "irc.hackint.org" = [
      "gluon"
    ];
  };
};
```

## ii usage

While the services are running, they accumulate IRC logs in `/home/justin/irc/${server}/${channel}/out`. Following the conversation is as easy as `tail -f out`. I'll probably automate the task of opening all the terminals `tail`ing the IRC channels. [People point at `multitail`](http://tools.suckless.org/ii/usage) in order to do this, but I felt like it would be overkill for this task.

Sending messages to a channel is as easy as piping the string in the corresponding named pipe called `in`.

## Conclusion

Setting this up was a great practice for learning Nix. It's really fun to reduce redundancy in a configuration file the same way as I do it in programming; by applying functions on datastructures. Also I now hold an archive of all IRC messages and I have a nice interface for interacting with them. E.g. it would be quite easy to implement automated notifications (if someone mentions my name) or even a bot functionality. I'm looking forward to the next Infrastrukturapokalypse, when I'll lean back, sip on my coffee and read some old Plausch from IRC, while everyone is freaking out about facebook (and their content) being offline.
