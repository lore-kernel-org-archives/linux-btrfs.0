Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from pepin.polanet.pl ([193.34.52.2]:53383 "EHLO pepin.polanet.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755940AbdLVQFp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 22 Dec 2017 11:05:45 -0500
Date: Fri, 22 Dec 2017 17:05:43 +0100
From: Tomasz Pala <gotar@polanet.pl>
To: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Unexpected raid1 behaviour
Message-ID: <20171222160543.GA4199@polanet.pl>
References: <23094.37316.66397.431081@tree.ty.sabi.co.uk>
 <91965e24-3b94-7334-c249-d8de5f585f29@gmail.com>
 <20171218194351.GA25245@polanet.pl>
 <7ff86029-5b0f-1d02-778a-af78c6f3e461@gmail.com>
 <20171219144644.GA9855@polanet.pl>
 <CAJCQCtSwfoSmAfFyP15xp-uysBY1kWyt65Jhf37g68YcPQ2QEA@mail.gmail.com>
 <20171219204155.GB14726@polanet.pl>
 <aac98fbf-c94b-1a88-f191-902146ff544f@gmail.com>
 <CAA91j0X_MZ+EjgZMNGrfChBdFed_G3oLttdpYjCOq-vERzoiKw@mail.gmail.com>
 <94b6b4cb-9f1a-c90b-5ffb-fb4d7385526b@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
In-Reply-To: <94b6b4cb-9f1a-c90b-5ffb-fb4d7385526b@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Dec 21, 2017 at 07:27:23 -0500, Austin S. Hemmelgarn wrote:

> No, it isn't.  You can just make the damn mount call with the supplied 
> options.  If it succeeds, the volume was ready, if it fails, it wasn't, 
> it's that simple, and there's absolutely no reason that systemd can't 
> just do that in a loop until it succeeds or a timeout is reached.  That 

There is no such loop, so if mount would happen before all the required
devices show up, it would either definitely fail, or if there were 'degraded'
in fstab, just start degraded.

> any of these issues with the volume being completely unusable in a 
> degraded state.
> 
> Also, it's not 'up to the filesystem', it's 'up to the underlying 
> device'.  LUKS, LVM, MD, and everything else that's an actual device 
> layer is what systemd waits on.  XFS, ext4, and any other filesystem 
> except BTRFS (and possibly ZFS, but I'm not 100% sure about that) 
> provides absolutely _NOTHING_ to wait on.  Systemd just chose to handle 

You wait for all the devices to settle. One might have dozen of drives
including some attached via network and it might take a time to become
available. Since systemd knows nothing about underlying components, it
simply waits for the btrfs itself to announce it's ready.

> BTRFS like a device layer, and not a filesystem, so we have this crap to 

As btrfs handles many devices in "lower part", this effectively is
device layer. Mounting /dev/sda happens to mount various other /dev/sd*
that are _not_ explicitly exposed, so there is really not an
alternative. Except for the 'mount loop' which is a no-go.

> deal with, as well as the fact that it makes it impossible to manually 
> mount a BTRFS volume with missing or failed devices in degraded mode 
> under systemd (because it unmounts it damn near instantly because it 
> somehow thinks it knows better than the user what the user wants to do).

This seems to be some distro-specific misconfiguration, didn't happen to
me on plain systemd/udev. What is the reproducing scenario?

>> This integration issue was so far silently ignored both by btrfs and
>> systemd developers. 
> It's been ignored by BTRFS devs because there is _nothing_ wrong on this 
> side other than the naming choice for the ioctl.  Systemd is _THE ONLY_ 
> init system which has this issue, every other one works just fine.

Not true - mounting btrfs without "btrfs device scan" doesn't work at
all without udev rules (that mimic behaviour of the command). Let me
repeat example from Dec 19th:

1. create 2-volume btrfs, e.g. /dev/sda and /dev/sdb,
2. reboot the system into clean state (init=/bin/sh), (or remove btrfs-scan tool),
3. try
mount /dev/sda /test - fails
mount /dev/sdb /test - works
4. reboot again and try in reversed order
mount /dev/sdb /test - fails
mount /dev/sda /test - works

> As far as the systemd side, I have no idea why they are ignoring it, 
> though I suspect it's the usual spoiled brat mentality that seems to be 
> present about everything that people complain about regarding systemd.

Explanation above. This is the point when _you_ need to stop ignoring
the fact, that you simply cannot just try mounting devices in a loop as
this would render any NAS/FC/iSCSI-backed or more complicated systems
unusable or hide problems in case of temporary problems with connection.

systemd waits for the _underlying_ device - unless btrfs exposes them as
a list of _actual_ devices to wait for, there is nothing except for
waiting for btrfs itself that systemd can do.

-- 
Tomasz Pala <gotar@pld-linux.org>
