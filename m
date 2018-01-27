Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f46.google.com ([209.85.218.46]:41166 "EHLO
        mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751467AbeA0U5a (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 27 Jan 2018 15:57:30 -0500
Received: by mail-oi0-f46.google.com with SMTP id m83so2522129oik.8
        for <linux-btrfs@vger.kernel.org>; Sat, 27 Jan 2018 12:57:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20180127110619.GA10472@polanet.pl>
References: <1516975360.4083556.1249069832.1B287A04@webmail.messagingengine.com>
 <5d342036-0de0-9bf7-3e9e-4885b62d8100@gmail.com> <1516978054.4103196.1249114200.76EC1546@webmail.messagingengine.com>
 <84c23047-522d-2529-5b16-d07ed8c28fc6@gmail.com> <1517035210.1252874.1249880112.19FABD13@webmail.messagingengine.com>
 <8607255b-98e7-5623-6f62-75d6f7cf23db@gmail.com> <569AC15F-174E-4C78-8FE5-6CE9E0BED479@yayon.me>
 <E23AAC7C-6CAA-4290-9CF1-19285DB31D05@yayon.me> <111ca301-f631-694d-93eb-b73a790f57d4@gmail.com>
 <20180127110619.GA10472@polanet.pl>
From: Chris Murphy <lists@colorremedies.com>
Date: Sat, 27 Jan 2018 13:57:29 -0700
Message-ID: <CAJCQCtT8_zdmc5oTLLa7AQt5_ObQchwBvFJCNf2UkC7ygn0rXw@mail.gmail.com>
Subject: Re: degraded permanent mount option
To: Tomasz Pala <gotar@polanet.pl>
Cc: "Majordomo vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jan 27, 2018 at 4:06 AM, Tomasz Pala <gotar@polanet.pl> wrote:

> As for the regular by-UUID mounts: these links are created by udev WHEN
> underlying devices appear. Does btrfs volume appear? No.

If I boot with rd.break=pre-mount I can absolutely mount a Btrfs
multiple volume that has a missing device by UUID with --uuid flag, or
by /dev/sdXY, along with -o degraded. And I can then use the exit
command to continue the startup process. In fact I can try to mount
without -o degraded, and the mount command "works" in that it does not
complain about an invalid node or UUID.

The Btrfs systemd udev rule is a sledghammer because it has no
timeout. It neither times out and tries to mount anyway, nor does it
time out and just drop to a dracut prompt. There are a number of
things in systemd startups that have timeouts, I have no idea how they
get defined, but that single thing would make this a lot better. Right
now the Btrfs udev rule means if all devices aren't available, hang
indefinitely.

I don't know systemd or systemd-udev well enough at all to know if
this rule can have a timer. Service units absolutely can have timers,
so maybe there's a way to marry a udev rule with a service which has a
timer. The absolute dumbest thing that's better than now, is at the
timer just fail and drop to a dracut prompt. Better would be to try a
normal mount anyway, which also fails to a dracut prompt, but
additionally gives us a kernel error for Btrfs (the missing device
open ctree error you'd expect to get when mounting without -o degraded
when you're missing a device). And even better would be a way for the
user to edit the service unit to indicate "upon timeout being reached,
use mount -o degraded rather than just mount". This is the simplest of
Boolean logic, so I'd be surprised if systemd doesn't offer a way for
us to do exactly what I'm describing.

Again the central problem is the udev rule now means "wait for device
to appear" with no timed fallback.

The mdadm case has this, and it's done by dracut. At this same stage
of startup with a  missing device, there is in fact no fs colume UUID
yet because the array hasn't started. Dracut+mdadm knows there's a
missing device so it's just iterating: look, sleep 3, look, sleep 3,
look, sleep 3. It's on a loop. And after that loop hits something like
100, the script says f it, start array anyway, so now there is a
degraded array, and for the first time the fs volume UUID appears, and
systemd goes "ahaha! mount that!" and it does it normally.

So the timer and timeout and what happens at the timeout is defined by
dracut. That's probably why the systemd folks say "not our problem"
and why the kernel folks say "not our problem".


> If btrfs pretends to be device manager it should expose more states,
> especially "ready to be mounted, but not fully populated" (i.e.
> "degraded mount possible"). Then systemd could _fallback_ after timing
> out to degraded mount automatically according to some systemd-level
> option.

No, mdadm is a device manager and it has no such facility. Something
issues a command to start the array anyway, and only then do you find
out if there are enough devices to start it. I don't understand the
value of knowing whether it is possible. Just try to mount it degraded
and then if it fails we fail, nothing can be done automatically it's
up to an admin.

And even if you had this "degraded mount possible" state, you still
need a timer. So just build the timer.

If all devices ready ioctl is true, the timer doesn't start, it means
all devices are available, mount normally.
If all devices ready ioctl is false, the timer starts, if all devices
appear later the ioctl goes to true, the timer is belayed, mount
normally.
If all devices ready ioctl is false, the timer starts, when the timer
times out, mount normally which fails and gives us a shell to
troubleshoot at.
OR
If all devices ready ioctl is false, the timer starts, when the timer
times out, mount with -o degraded which either succeeds and we boot or
it fails and we have a troubleshooting shell.


The central problem is the lack of a timer and time out.


> Unless there is *some* signalling from btrfs, there is really not much
> systemd can *safely* do.

That is not true. It's not how mdadm works anyway.


-- 
Chris Murphy
