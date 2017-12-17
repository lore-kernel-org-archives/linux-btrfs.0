Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:36630 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1752345AbdLQMBL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 17 Dec 2017 07:01:11 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1eQXay-0001mS-IQ
        for linux-btrfs@vger.kernel.org; Sun, 17 Dec 2017 12:59:04 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Unexpected raid1 behaviour
Date: Sun, 17 Dec 2017 11:58:57 +0000 (UTC)
Message-ID: <pan$36ed4$200dd538$4324239e$ed0f9f4@cox.net>
References: <5A357909.8010206@yandex.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dark Penguin posted on Sat, 16 Dec 2017 22:50:33 +0300 as excerpted:

> Could someone please point me towards some read about how btrfs handles
> multiple devices? Namely, kicking faulty devices and re-adding them.
> 
> I've been using btrfs on single devices for a while, but now I want to
> start using it in raid1 mode. I booted into an Ubuntu 17.10 LiveCD and
> tried to see how does it handle various situations. The experience left
> me very surprised; I've tried a number of things, all of which produced
> unexpected results.
> 
> I create a btrfs raid1 filesystem on two hard drives and mount it.
> 
> - When I pull one of the drives out (simulating a simple cable failure,
> which happens pretty often to me), the filesystem sometimes goes
> read-only. ???
> - But only after a while, and not always. ???
> - When I fix the cable problem (plug the device back), it's immediately
> "re-added" back. But I see no replication of the data I've written onto
> a degraded filesystem... Nothing shows any problems, so "my filesystem
> must be ok". ???
> - If I unmount the filesystem and then mount it back, I see all my
> recent changes lost (everything I wrote during the "degraded" period). -
> If I continue working with a degraded raid1 filesystem (even without
> damaging it further by re-adding the faulty device), after a while it
> won't mount at all, even with "-o degraded".
> 
> I can't wrap my head about all this. Either the kicked device should not
> be re-added, or it should be re-added "properly", or it should at least
> show some errors and not pretend nothing happened, right?..
> 
> I must be missing something. Is there an explanation somewhere about
> what's really going on during those situations? Also, do I understand
> correctly that upon detecting a faulty device (a write error), nothing
> is done about it except logging an error into the 'btrfs device stats'
> report? No device kicking, no notification?.. And what about degraded
> filesystems - is it absolutely forbidden to work with them without
> converting them to a "single" filesystem first?..
> 
> On Ubuntu 17.10, there's Linux 4.13.0-16 and btrfs-progs 4.12-1 .

Btrfs device handling at this point is still "development level" and very 
rough, but there's a patch set in active review ATM that should improve 
things dramatically, perhaps as soon as 4.16 (4.15 is already well on the 
way).

Basically, at this point btrfs doesn't have "dynamic" device handling.  
That is, if a device disappears, it doesn't know it.  So it continues 
attempting to write to (and read from, but the reads are redirected) the 
missing device until things go bad enough it kicks to read-only for 
safety.

If a device is added back, the kernel normally shuffles device names and 
assigns a new one.  Btrfs will see it and list the new device, but it's 
still trying to use the old one internally.  =:^(

Thus, if a device disappears, to get it back you really have to reboot, 
or at least unload/reload the btrfs kernel module, in ordered to clear 
the stale device state and have btrfs rescan and reassociate devices with 
the matching filesystems.

Meanwhile, once a device goes stale -- other devices in the filesystem 
have data that should have been written to the stale one but it was gone 
so the data couldn't get to it -- once you do the module unload/reload or 
reboot cycle and btrfs picks up the device again, you should immediately 
do a btrfs scrub, which will detect and "catch up" the differences.

Btrfs tracks atomic filesystem updates via a monotonically increasing 
generation number, aka transaction-id (transid).  When a device goes 
offline, its generation number of course gets stuck at the point it went 
offline, while the other devices continue to update their generation 
numbers.

When a stale device is readded, btrfs should automatically find and use 
the device with the latest generation, but the old one isn't 
automatically caught up -- a scrub is the mechanism by which you do this.

One thing you do **NOT** want to do is degraded-writable mount one 
device, then the other device, of a raid1 pair, because that'll diverge 
the two with new data on each, and that's no longer simple to correct.  
If you /have/ to degraded-writable mount a raid1, always make sure it's 
the same one mounted writable if you want to combine them again.  If you 
/do/ need to recombine two diverged raid1 devices, the only safe way to 
do so is to wipe the one so btrfs has only the one copy of the data to go 
on, and add the wiped device back as a new device.

Meanwhile, until /very/ recently... 4.13 may not be current enough... if 
you mounted a two-device raid1 degraded-writable, btrfs would try to 
write and note that it couldn't do raid1 because there wasn't a second 
device, so it would create single chunks to write into.

And the older filesystem safe-mount mechanism would see those single 
chunks on a raid1 and decide it wasn't safe to mount the filesystem 
writable at all after that, even if all the single chunks were actually 
present on the remaining device.

The effect was that if a device died, you had exactly one degraded-
writable mount to replace it successfully.  If you didn't complete the 
replace in that single chance writable mount, the filesystem would refuse 
to mount writable again, and thus it was impossible to repair the 
filesystem since that required a writable mount and that was no longer 
possible!  Fortunately the filesystem could still be mounted degraded-
readonly (unless there was some other problem), allowing people to at 
least get at the read-only data to copy it elsewhere.

With a new enough btrfs, while btrfs will still create those single 
chunks on a degraded-writable mount of a raid1, it's at least smart 
enough to do per-chunk checks to see if they're all available on existing 
devices (none only on the missing device), and will continue to allow 
degraded-writable mounting if so.

But once the filesystem is back to multi-device (with writable space on 
at least two devices), a balance-convert of those single chunks to raid1 
should be done, otherwise if the device with them on it goes...

And there's work on allowing it to do only single-copy, thus incomplete-
raid1, chunk writes as well.  This should prevent the single mode chunks 
entirely, thus eliminating the need for the balance-convert, tho a scrub 
would still be needed to fully sync back up.  But I'm not sure what the 
status is on that.

Meanwhile, as mentioned above, there's active work on proper dynamic 
btrfs device tracking and management.  It may or may not be ready for 
4.16, but once it goes in, btrfs should properly detect a device going 
away and react accordingly, and it should detect a device coming back as 
a different device too.  As I write this it occurs to me that I've not 
read close enough to know if it actually initiates scrub/resync on its 
own in the current patch set, but that's obviously an eventual goal if 
not.

Longer term, there's further patches that will provide a hot-spare 
functionality, automatically bringing in a device pre-configured as a hot-
spare if a device disappears, but that of course requires that btrfs 
properly recognize devices disappearing and coming back first, so one 
thing at a time.  Tho as originally presented, that hot-spare 
functionality was a bit limited -- it was a global hot-spare list, and 
with multiple btrfs of different sizes and multiple hot-spare devices 
also of different sizes, it would always just pick the first spare on the 
list for the first btrfs needing one, regardless of whether the size was 
appropriate for that filesystem or not.  By the time the feature actually 
gets merged it may have changed some, and regardless, it should 
eventually get less limited, but that's _eventually_, with a target time 
likely still in years, so don't hold your breath.


I think that answers most of your questions.  Basically, you have to be 
quite careful with btrfs raid1 today, as btrfs simply doesn't have the 
automated functionality to handle it yet.  It's still possible to do two-
device-only raid1 and replace a failed device when you're down to one, 
but it's not as easy or automated as more mature raid options such as 
mdraid, and you do have to keep on top of it as a result.  But it can and 
does work reasonably well for those (like me) who use btrfs raid1 as 
their "daily driver", as long as you /do/ keep on top of it... and don't 
try to use raid1 as a replacement for real backups, because it's *not* a 
backup! =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

