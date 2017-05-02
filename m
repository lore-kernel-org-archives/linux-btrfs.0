Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:34986 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751591AbdEBStb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 May 2017 14:49:31 -0400
Date: Tue, 2 May 2017 20:49:23 +0200
From: Adam Borowski <kilobyte@angband.pl>
To: Andrei Borzenkov <arvidjaar@gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Can I see what device was used to mount btrfs?
Message-ID: <20170502184923.jdpfx3pwkl5avdph@angband.pl>
References: <1e2e2e5c-5ee8-85c1-1db4-74293d8c9c1e@gmail.com>
 <20170502135820.2ft7bsoceeqhnbqf@angband.pl>
 <CAA91j0V97dCb+j_thg0oi7B4D29VVKcqtRcpCWbgQyzi+FScKA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAA91j0V97dCb+j_thg0oi7B4D29VVKcqtRcpCWbgQyzi+FScKA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 02, 2017 at 05:19:34PM +0300, Andrei Borzenkov wrote:
> On Tue, May 2, 2017 at 4:58 PM, Adam Borowski <kilobyte@angband.pl> wrote:
> > On Sun, Apr 30, 2017 at 08:47:43AM +0300, Andrei Borzenkov wrote:
> >> systemd waits for the final device that makes btrfs complete and mounts
> >> it using this device name.
> >
> >> But in /proc/self/mountinfo we actually see another
> >> device name. Due to peculiarities of systemd implementation this device
> >> "does not exist" from systemd PoV.
> >>
> >> Looking at btrfs code I start to suspect that we actually do not know
> >> what device was used to mount it at all.
> >>
> >> So we always show device with the smallest devid, irrespectively of what
> >> device was actually used to mount it.
> >
> > Devices come and go (ok, it's not like you hot-remove disks every day,
> > but...).  Storing the device that started the mount is pointless: btrfs
> > can handle removal fine so such a stored device would point nowhere -- or
> > worse, to some unrelated innocent disk you put in for data recovery (you may
> > have other plans than re-provisioning that raid).
> 
> Yes, I understand all of this, you do not need to convince me. OTOH
> the problem is real - we need to have some way to order btrfs mounts
> during bootup. In the past it was solved by delays. Systemd tries to
> eliminate ad hoc delays ... which is by itself not bad. So what can be
> utilized from btrfs side to implement ordering? We need /something/ to
> wait for. It could be virtual device that represents btrfs RAID and
> have state online/offline (similar to Linux MD).

It's not so simple -- such a btrfs device would have THREE states:

1. not mountable yet (multi-device with not enough disks present)
2. mountable ro / rw-degraded
3. healthy

The distinction between 1 and 2 is important, especially because systemd for
some reason insists on forcing unmount if it thinks the filesystem is in a
bad state (why?!?).  On distributions that follow the traditional remount
scheme (ie, you mount ro during boot, run fsck/whatever (no-op for btrfs),
then remount rw), starting as soon as we're in state 2 would be faster.  It
would also allow automatically going degraded if a timeout is hit[1].

To distinguish between 1 and 2 you need to halfway mount the filesystem, at
least to read the chunk tree (Qu's "why the heck it wasn't merged 2 years
ago" chunk check patch would help).

Naively thinking, it might be tempting to have only two states, varying it
whether the filesystem is already mounted -- currently it's 1+2 vs 3; it
would be: before mount: 1+2 vs 3, after mount: 1 vs 2+3.

But this would lead to breakage in corner cases.

For example: a box has a 3-way raid1 on sda sdb sdc.  Due to a cable not
being firmly seated, power supply or controller having a hiccup, etc,
suddenly sda goes offline.  Btrfs handles that fine, the admin gets worried
and hot-plugs a fourth disk, adding it to the raid.  Reboot.  sda gets up
first, boot goes fine so far, mountall/systemd starts, wants to mount that
filesystem.  sda appears to be fine, systemd reads it and sees there are _3_
disks (as obviously sda doesn't yet know about the fourth).  As sdd was a
random slow crap disk the admin happened to have on the shelf, it's not yet
up.  So systemd sees sda sdb sdc on -- they have all the device IDs it's
looking for, the count is ok, so it assumes all is fine.  It tries to mount,
but btrfs then properly notices there are four disks needed, and because
there was no -odegraded, the mount fails.  Boom.

Thus, there's no real way to know if the mount will succeed beforehand.


> It could be some daemon that waits for btrfs to become complete.  Do we
> have something?

Such a daemon would also have to read the chunk tree.


Meow!

[1]. Not entirely sure if that's a good default -- in one of my boxes, two
disks throw scary errors like UnrecovData BadCRC then after ninetysomething
seconds all goes well, although md (/ is on a 5GB 5-way raid1 md) first goes
degraded then starts autorecovery.  As systemd likes timeouts of 90 seconds,
just a few seconds shy of what this box needs to settle, having systemd and
auto-degrade there would lead to unpaired blocks, which btrfs doesn't yet
repair without being ordered to by hand.

-- 
Don't be racist.  White, amber or black, all beers should be judged based
solely on their merits.  Heck, even if occasionally a cider applies for a
beer's job, why not?
On the other hand, corpo lager is not a race.
