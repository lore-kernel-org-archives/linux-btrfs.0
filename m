Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:46610 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752485AbcGMHVd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Jul 2016 03:21:33 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1bNETn-0004Fm-83
	for linux-btrfs@vger.kernel.org; Wed, 13 Jul 2016 09:21:11 +0200
Received: from ip-64-134-228-164.public.wayport.net ([64.134.228.164])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 13 Jul 2016 09:21:11 +0200
Received: from 1i5t5.duncan by ip-64-134-228-164.public.wayport.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 13 Jul 2016 09:21:11 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: ERROR: ioctl(DEV_REPLACE_START) failed on "/mnt": Read-only
 file system
Date: Wed, 13 Jul 2016 07:21:04 +0000 (UTC)
Message-ID: <pan$33005$b43c1faa$391235c7$48d59e33@cox.net>
References: <d10c846e-36a4-44b6-1d59-65fae30d8e59@rz.uni-freiburg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Tamas Baumgartner-Kis posted on Tue, 12 Jul 2016 13:46:56 +0200 as
excerpted:

> Hi,
> 
> 
> I have a problem with the current BTRFS 4.6
> 
> 
> I'm running a Archlinux in a KVM to test BTRFS.
> 
> First I played with one device and subvolumes.
> 
> After that I added a second device to make a raid1.
> 
> # btrfs device add /dev/sdb /mnt
> # btrfs balance start -dconvert=raid1 -mconvert=raid1 /mnt

So both data and metadata.  Thanks for specifying the command as
sometimes it's unclear that the conversion was done for both, or
just one.

> To make a stresstest I removed the first device and wanted to
> boot, but unfortunately the system couldn't boot.
> 
> So I booted into a liveSystem:
> 
> #uname -a
> Linux archiso 4.6.3-1-ARCH #1 SMP PREEMPT Fri Jun 24 21:19:13 CEST 2016
> x86_64 GNU/Linux
> 
> First I tried to mount the "leftover" device with the degraded option
> 
> # mount -o degraded /dev/sda /mnt
> mount: wrong fs type, bad option, bad superblock on /dev/sda,
>        missing codepage or helper program, or other error
> 
>        In some cases useful info is found in syslog - try
>        dmesg | tail or so.
> 
> 
> but this works only if I also use the read-only option.
> 
> # mount -oro,degraded /dev/sda /mnt
> 
> If I try then to replace the missing device I got an error
> 
> # btrfs replace start -B 1 /dev/sdb /mnt
> ERROR: ioctl(DEV_REPLACE_START) failed on "/mnt": Read-only file system

That's expected.  Adding/deleting/replacing a device requires a
writable filesystem.

> Hire are some additional info about the system
> 
> #  btrfs --version
> btrfs-progs v4.6
> 
> 
> 
> # btrfs fi show
> Label: 'hdd0'  uuid: 97b5c51a-65d3-4a84-9382-9b99756ca4ab
> 	Total devices 2 FS bytes used 1.09GiB
> 	devid    2 size 10.00GiB used 3.56GiB path /dev/sda
> 	*** Some devices missing
> 
> 
> 
> # btrfs fi df /mnt
> Data, RAID1: total=2.00GiB, used=1.04GiB
> Data, single: total=1.00GiB, used=640.00KiB
> System, RAID1: total=32.00MiB, used=16.00KiB
> System, single: total=32.00MiB, used=0.00B
> Metadata, RAID1: total=256.00MiB, used=54.02MiB
> Metadata, single: total=256.00MiB, used=256.00KiB
> GlobalReserve, single: total=32.00MiB, used=0.00B

This reveals the problem.  You have single chunks in addition
to the raid1 chunks.  Current btrfs will refuse to mount
writable with a device missing in such a case, in ordered
to prevent further damage.

Which is a problem, because current btrfs raid1 requires at
least two devices to write further raid1 content.  So what
happens when you have a two-device raid1 degraded to a
single device, is btrfs can no longer write raid1, because
that requires two devices, so it starts writing single
mode chunks.

Which means as long as you repair the raid1 in that same
mount session, you're good.

But you only get that one chance.  If you don't repair it
in that first mount session after it starts writing to the
degraded raid1 and thus creates those single mode chunks,
you don't get a second chance, because once those single
mode chunks are there it will refuse to mount writable
with a missing device.  All you can do then is mount
degraded read-only, and copy your data off.


This is a known issue with *current* btrfs.  There are
actually two sets of patches in discussion to fix the
problem, but I don't believe (and your results support
it as well) that 4.6 got them.  I'm not actually sure
what 4.7 status is as I've not tracked it /that/ closely.

The first attempt at a fix was a patch set that
had btrfs check each chunk, and if all chunks
were accounted for, as they will be on an originally
two-device raid1 that had a device dropped and then
had single-mode chunks written to the other one, it
would still allow degraded writable mount.  Only if
some chunks end up not available as they're on the
missing device, would the filesystem only allow
degraded, read-only mounting.  This is referred to
as the per-chunk check patchset.

But while that strategy and patch-set worked, further
discussion decided it was a work-around to the actual
problem -- internally, btrfs tracks two numbers for
minimum allowed devices for writable mount, full
functionality, and degraded but everything still
available.  For raid1 full functionality, obviously
the minimum is two devices, but the degraded minimum
should be just one device, of course also requiring
that no more than a single device should be missing,
since btrfs raid1 is only two copies no matter the
number of devices (above 1).

The real bug was decided to be that for raid1,
btrfs had both the minimums set to two devices.
Which is why the forced-switch to single-mode
chunk writing code was added in the first place, as
a workaround to /this/ problem, instead of
fixing it by allowing writing to only a single
device with the other copy missing, if degraded
was in the options.

However, by the time that decision was reached
and a patch created and in-testing to change
the raid1 mode degraded writable minimum, it was
already too late in the 4.6 cycle to get such
a big change in.

Meanwhile, the other problem was that the initial
per-chunk check patches were added to a patch-set
that wasn't yet considered mature and thus wasn't
picked for early 4.6.  The delay was fortunate in
that it allowed the real problem to be discovered
and a patch created, but that's why a fix may not
have made it into 4.7 either, because if the patch
set it's a part of is still not considered mature,
it would not have been pulled for 4.7 either, and
the new patch fixing the real problem would still
be in limbo along with it.

Unless of course it was individually cherry-picked
apart from the patchset as a whole.  As a user not
a dev myself, I followed the discussion, but I haven't
followed developments close enough to know what the
current status is, and whether the second patch fix
actually made it into 4.7, or not.

So in summary, it's a known problem, with an early
proposed patch that was decided to be really a
work-around that didn't fix the real problem, and a
second proposed patch now available, but I don't
know the status of testing and whether it reached
mainline in time for 4.7.

But they /are/ aware of the problem and /are/ working
on it.  In the mean time, you have three choices.
You can:

1)  Try to be careful and actually do a replace
on the first degraded writable mount of a btrfs raid1,
because you know that's the only chance you'll get with
current code to repair it.

2) Find and apply one or the other patches manually.

3) Just let the thing go read-only if it's going
to, and copy everything over to a different
filesystem from the read-only btrfs before blowing
it away, if it comes to that.


But meanwhile, while the above btrfs fi df reveals
the problem as we see it on the existing filesystem,
it says nothing about how it got that way.  Your
sequence above doesn't mention mounting the
degraded raid1 writable once, for it to create those
single-mode chunks that are now blocking writable
mount, but that's one way it could have happened.

Another way would be if the balance-conversion from
single mode to raid1 never properly completed in the
first place.  But I'm assuming it did and that you
had a full raid1 btrfs fi df report at one point.

A third way would be if some other bug triggered
btrfs to suddenly start writing single mode
chunks.  There were some bugs like that in the
past, but they've been fixed for some time.  But
perhaps there are similar newer bugs, or perhaps
you ran the filesystem on an old kernel with
that bug.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

