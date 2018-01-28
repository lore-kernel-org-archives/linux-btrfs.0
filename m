Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from pepin.polanet.pl ([193.34.52.2]:46511 "EHLO pepin.polanet.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751905AbeA1AAS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 27 Jan 2018 19:00:18 -0500
Date: Sun, 28 Jan 2018 01:00:16 +0100
From: Tomasz Pala <gotar@polanet.pl>
To: "Majordomo vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: degraded permanent mount option
Message-ID: <20180128000016.GB16927@polanet.pl>
References: <5d342036-0de0-9bf7-3e9e-4885b62d8100@gmail.com>
 <1516978054.4103196.1249114200.76EC1546@webmail.messagingengine.com>
 <84c23047-522d-2529-5b16-d07ed8c28fc6@gmail.com>
 <1517035210.1252874.1249880112.19FABD13@webmail.messagingengine.com>
 <8607255b-98e7-5623-6f62-75d6f7cf23db@gmail.com>
 <569AC15F-174E-4C78-8FE5-6CE9E0BED479@yayon.me>
 <E23AAC7C-6CAA-4290-9CF1-19285DB31D05@yayon.me>
 <111ca301-f631-694d-93eb-b73a790f57d4@gmail.com>
 <20180127110619.GA10472@polanet.pl>
 <CAJCQCtT8_zdmc5oTLLa7AQt5_ObQchwBvFJCNf2UkC7ygn0rXw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
In-Reply-To: <CAJCQCtT8_zdmc5oTLLa7AQt5_ObQchwBvFJCNf2UkC7ygn0rXw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jan 27, 2018 at 13:57:29 -0700, Chris Murphy wrote:

> The Btrfs systemd udev rule is a sledghammer because it has no
> timeout. It neither times out and tries to mount anyway, nor does it
> time out and just drop to a dracut prompt. There are a number of
> things in systemd startups that have timeouts, I have no idea how they
> get defined, but that single thing would make this a lot better. Right
> now the Btrfs udev rule means if all devices aren't available, hang
> indefinitely.

You mix udev with systemd:
- udev doesn't wait for anything - it REACTS to events. Blame the part
  that doesn't emit a one that you want.
- systemd WAITS for device to appear AND SETTLE. The timeout for devices
  is 90 seconds by default and can be changed in fstab with
  x-systemd.device-timeout.

It cannot "just try-mount this-or-that ON boot" as there is NO state of
"booting" or "shutting down" in systemd flow, there is only a chain of
events.

Mounting a device happens when it becomes available. If the device is
not crucial for booting up, just add the "nofail". If you want to lie
about the device being available, put the appropriate code into device
handler (btrfs could parse kernel cmdline and return READY for degraded).

> this rule can have a timer. Service units absolutely can have timers,
> so maybe there's a way to marry a udev rule with a service which has a
> timer. The absolute dumbest thing that's better than now, is at the
> timer just fail and drop to a dracut prompt. Better would be to try a
> normal mount anyway, which also fails to a dracut prompt, but
> additionally gives us a kernel error for Btrfs (the missing device
> open ctree error you'd expect to get when mounting without -o degraded
> when you're missing a device). And even better would be a way for the
> user to edit the service unit to indicate "upon timeout being reached,
> use mount -o degraded rather than just mount". This is the simplest of
> Boolean logic, so I'd be surprised if systemd doesn't offer a way for
> us to do exactly what I'm describing.

Any fallback to degraded mode requires the volume manager to handle this
gracefuly first. Until btrfs is degraded-safe, systemd cannot offer to
mount it degraded in _any_ way.

> Again the central problem is the udev rule now means "wait for device
> to appear" with no timed fallback.

If I got photos on external drive, is this also the udev rule that waits
for me to plug it in?

You should blame btrfs.ko for not "plugging in" (emiting event to udev).

> The mdadm case has this, and it's done by dracut. At this same stage
> of startup with a  missing device, there is in fact no fs colume UUID
> yet because the array hasn't started. Dracut+mdadm knows there's a
> missing device so it's just iterating: look, sleep 3, look, sleep 3,
> look, sleep 3. It's on a loop. And after that loop hits something like
> 100, the script says f it, start array anyway, so now there is a

So you need some btrfsd to iterate and eventually say "go degraded",
as systemd isn't the volume manager here.

> degraded array, and for the first time the fs volume UUID appears, and
> systemd goes "ahaha! mount that!" and it does it normally.

You see for yourself, systemd mounts ready md device. It doesn't handle
the 'ready-or-not-yet' timing out logic.

> So the timer and timeout and what happens at the timeout is defined by
> dracut. That's probably why the systemd folks say "not our problem"
> and why the kernel folks say "not our problem".

And they are both right - there should be btrfsd for handling this.
Well, except for the kernel cmdline that should be parsed by kernel
guys. But since it is impossible to assemble multidevice btrfs by kernel
itself anyway (i.e. without initrd) this could all go to the daemon.

>> If btrfs pretends to be device manager it should expose more states,
>> especially "ready to be mounted, but not fully populated" (i.e.
>> "degraded mount possible"). Then systemd could _fallback_ after timing
>> out to degraded mount automatically according to some systemd-level
>> option.
> 
> No, mdadm is a device manager and it has no such facility. Something

It has - the ultimate "signalling" in case of mdadm is apperance of
/dev/mdX device. Until the device won't came up, the systemd obviously
won't mount it.
In case of btrfs the situation is abnormal - there IS /dev/sda1 device
available, but in fact it might be not available. So there is the IOCTL
to check if the available device is really available. And guess what -
it returns NOT_READY... And you want systemd to mount this
ready-not_ready? The same way you could ask systemd to mount MD/LVM
device that is not existing.

This is btrfs fault to:
1. reuse device node for different purposes [*],
2. lack the timing-out/degraded logic implemented somewhere.

> issues a command to start the array anyway, and only then do you find
> out if there are enough devices to start it. I don't understand the
> value of knowing whether it is possible. Just try to mount it degraded
> and then if it fails we fail, nothing can be done automatically it's
> up to an admin.

It can't mount degraded, because the "missing" device might go online a
few seconds ago.

> And even if you had this "degraded mount possible" state, you still
> need a timer. So just build the timer.

Exactly! This "timer" is btrfs-specific daemon that should be shipped
with btrfs-tools. Well, maybe not the actual daemon, as btrfs handles
incremental assembly on it's own, just the appropriate units and
signalling.

For mdadm there is --incremental used for gradually assemble via udev rule:
https://git.kernel.org/pub/scm/utils/mdadm/mdadm.git/tree/udev-md-raid-assembly.rules
(this also fires timer)

and the systemd part for timing-out and degraded fallback:
https://git.kernel.org/pub/scm/utils/mdadm/mdadm.git/tree/systemd
mdadm-last-resort@.timer
mdadm-last-resort@.service

There is appropriate code in LVM as well, using lvmetad, but this one is easier.

So, let's step by step your proposal:

> If all devices ready ioctl is true, the timer doesn't start, it means
> all devices are available, mount normally.

sure

> If all devices ready ioctl is false, the timer starts, if all devices
> appear later the ioctl goes to true, the timer is belayed, mount
> normally.

sure

> If all devices ready ioctl is false, the timer starts, when the timer
> times out, mount normally which fails and gives us a shell to
> troubleshoot at.
> OR
> If all devices ready ioctl is false, the timer starts, when the timer
> times out, mount with -o degraded which either succeeds and we boot or
> it fails and we have a troubleshooting shell.

Don't mix layers - just image your /dev/sda1 is not there and you simply
cannot even try to mount it; this should be done like this:

If all devices ready ioctl is false, the timer starts, when the timer
times out, TELL THE KERNEL THAT WE WANT DEGRADED MOUNT. This in turn
should switch IOCTL response to "OK, go degraded" which in turn would
make udev rule to raise the flag[*] and then systemd could mount this.

This is important that the kernel would be instructed in a way, not the
last one, as this gives the chance to pass the degraded option using the
cmdline.

> The central problem is the lack of a timer and time out.

You got mdadm-last-resort@.timer/service above, if btrfs doesn't lack
anything, as you all state here, this should be easy to make this work.
Go ahead please.

>> Unless there is *some* signalling from btrfs, there is really not much
>> systemd can *safely* do.
> 
> That is not true. It's not how mdadm works anyway.

Yes it does. You can't mount mdadm until /dev/mdX appears, which happens
when array get's fully assembled *OR* times out and kernel get's
instructed to run array as degraded, which effects in /dev/mdX appearing.
There is NO additional logic in systemd.

This is NOT systemd that assembles degraded mdadm, this is mdadm that
tells the kernel to assemble it and systemd mounts READY md.
Moreover, systemd gives you a set of tools that you can use for timers.

[*] the udev flag is required to distinguish /dev/sda1 block device from
/dev/sda1 btrfs-volume device being ready. If there were separate device
created, there would be no need for this entire IOCTL.

-- 
Tomasz Pala <gotar@pld-linux.org>
