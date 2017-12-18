Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:52406 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750708AbdLRFKm (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Dec 2017 00:10:42 -0500
Subject: Re: Unexpected raid1 behaviour
To: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
References: <5A357909.8010206@yandex.ru>
 <pan$36ed4$200dd538$4324239e$ed0f9f4@cox.net>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <3acce035-2568-27c9-d251-8a22a38497fd@oracle.com>
Date: Mon, 18 Dec 2017 13:11:17 +0800
MIME-Version: 1.0
In-Reply-To: <pan$36ed4$200dd538$4324239e$ed0f9f4@cox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



  Nice status update about btrfs volume manager. Thanks.

  Below I have added the names of the patch in ML/wip addressing
  the current limitations.

On 12/17/2017 07:58 PM, Duncan wrote:
> Dark Penguin posted on Sat, 16 Dec 2017 22:50:33 +0300 as excerpted:
> 
>> Could someone please point me towards some read about how btrfs handles
>> multiple devices? Namely, kicking faulty devices and re-adding them.
>>
>> I've been using btrfs on single devices for a while, but now I want to
>> start using it in raid1 mode. I booted into an Ubuntu 17.10 LiveCD and
>> tried to see how does it handle various situations. The experience left
>> me very surprised; I've tried a number of things, all of which produced
>> unexpected results.
>>
>> I create a btrfs raid1 filesystem on two hard drives and mount it.
>>
>> - When I pull one of the drives out (simulating a simple cable failure,
>> which happens pretty often to me), the filesystem sometimes goes
>> read-only. ???
>> - But only after a while, and not always. ???
>> - When I fix the cable problem (plug the device back), it's immediately
>> "re-added" back. But I see no replication of the data I've written onto
>> a degraded filesystem... Nothing shows any problems, so "my filesystem
>> must be ok". ???
>> - If I unmount the filesystem and then mount it back, I see all my
>> recent changes lost (everything I wrote during the "degraded" period). -
>> If I continue working with a degraded raid1 filesystem (even without
>> damaging it further by re-adding the faulty device), after a while it
>> won't mount at all, even with "-o degraded".
>>
>> I can't wrap my head about all this. Either the kicked device should not
>> be re-added, or it should be re-added "properly", or it should at least
>> show some errors and not pretend nothing happened, right?..
>>
>> I must be missing something. Is there an explanation somewhere about
>> what's really going on during those situations? Also, do I understand
>> correctly that upon detecting a faulty device (a write error), nothing
>> is done about it except logging an error into the 'btrfs device stats'
>> report? No device kicking, no notification?.. And what about degraded
>> filesystems - is it absolutely forbidden to work with them without
>> converting them to a "single" filesystem first?..
>>
>> On Ubuntu 17.10, there's Linux 4.13.0-16 and btrfs-progs 4.12-1 .
> 
> Btrfs device handling at this point is still "development level" and very
> rough, but there's a patch set in active review ATM that should improve
> things dramatically, perhaps as soon as 4.16 (4.15 is already well on the
> way).
> 
> Basically, at this point btrfs doesn't have "dynamic" device handling.
> That is, if a device disappears, it doesn't know it.  So it continues
> attempting to write to (and read from, but the reads are redirected) the
> missing device until things go bad enough it kicks to read-only for
> safety.

   btrfs: introduce device dynamic state transition to failed

> If a device is added back, the kernel normally shuffles device names and
> assigns a new one.  Btrfs will see it and list the new device, but it's
> still trying to use the old one internally.  =:^(

   btrfs: handle dynamically reappearing missing device

> Thus, if a device disappears, to get it back you really have to reboot,
> or at least unload/reload the btrfs kernel module, in ordered to clear
> the stale device state and have btrfs rescan and reassociate devices with
> the matching filesystems.
> 
> Meanwhile, once a device goes stale -- other devices in the filesystem
> have data that should have been written to the stale one but it was gone
> so the data couldn't get to it -- once you do the module unload/reload or
> reboot cycle and btrfs picks up the device again, you should immediately
> do a btrfs scrub, which will detect and "catch up" the differences.
 >
> Btrfs tracks atomic filesystem updates via a monotonically increasing
> generation number, aka transaction-id (transid).  When a device goes
> offline, its generation number of course gets stuck at the point it went
> offline, while the other devices continue to update their generation
> numbers.
 >
> When a stale device is readded, btrfs should automatically find and use
> the device with the latest generation, but the old one isn't
> automatically caught up -- a scrub is the mechanism by which you do this.
>
> One thing you do **NOT** want to do is degraded-writable mount one
> device, then the other device, of a raid1 pair, because that'll diverge
> the two with new data on each, and that's no longer simple to correct.
> If you /have/ to degraded-writable mount a raid1, always make sure it's
> the same one mounted writable if you want to combine them again.  If you
> /do/ need to recombine two diverged raid1 devices, the only safe way to
> do so is to wipe the one so btrfs has only the one copy of the data to go
> on, and add the wiped device back as a new device.

   btrfs: handle volume split brain scenario

> Meanwhile, until /very/ recently... 4.13 may not be current enough... if
> you mounted a two-device raid1 degraded-writable, btrfs would try to
> write and note that it couldn't do raid1 because there wasn't a second
> device, so it would create single chunks to write into. >
> And the older filesystem safe-mount mechanism would see those single
> chunks on a raid1 and decide it wasn't safe to mount the filesystem
> writable at all after that, even if all the single chunks were actually
> present on the remaining device.
 >
> The effect was that if a device died, you had exactly one degraded-
> writable mount to replace it successfully.  If you didn't complete the
> replace in that single chance writable mount, the filesystem would refuse
> to mount writable again, and thus it was impossible to repair the
> filesystem since that required a writable mount and that was no longer
> possible!  Fortunately the filesystem could still be mounted degraded-
> readonly (unless there was some other problem), allowing people to at
> least get at the read-only data to copy it elsewhere.
 >
> With a new enough btrfs, while btrfs will still create those single
> chunks on a degraded-writable mount of a raid1, it's at least smart
> enough to do per-chunk checks to see if they're all available on existing
> devices (none only on the missing device), and will continue to allow
> degraded-writable mounting if so.

   (v4.14)
   btrfs: Introduce a function to check if all chunks a OK for degraded 
rw mount

> But once the filesystem is back to multi-device (with writable space on
> at least two devices), a balance-convert of those single chunks to raid1
> should be done, otherwise if the device with them on it goes...
 >
> And there's work on allowing it to do only single-copy, thus incomplete-
> raid1, chunk writes as well.  This should prevent the single mode chunks
> entirely, thus eliminating the need for the balance-convert, tho a scrub
> would still be needed to fully sync back up.  But I'm not sure what the
> status is on that.

   btrfs: create degraded-RAID1 chunks
   (Patch is wip still. There is a good workaround).

> Meanwhile, as mentioned above, there's active work on proper dynamic
> btrfs device tracking and management. 

   btrfs: Introduce device pool sysfs attributes
   (needs revival)

> It may or may not be ready for
> 4.16, but once it goes in, btrfs should properly detect a device going
> away and react accordingly, and it should detect a device coming back as
> a different device too.  As I write this it occurs to me that I've not
> read close enough to know if it actually initiates scrub/resync on its
> own in the current patch set, but that's obviously an eventual goal if
> not.

   Right. It doesn't as of now, its in my list of things to fix.

> Longer term, there's further patches that will provide a hot-spare
> functionality, automatically bringing in a device pre-configured as a hot-
> spare if a device disappears, but that of course requires that btrfs
> properly recognize devices disappearing and coming back first, so one
> thing at a time.  Tho as originally presented, that hot-spare
> functionality was a bit limited -- it was a global hot-spare list, and
> with multiple btrfs of different sizes and multiple hot-spare devices
> also of different sizes, it would always just pick the first spare on the
> list for the first btrfs needing one, regardless of whether the size was
> appropriate for that filesystem or not.  By the time the feature actually
> gets merged it may have changed some, and regardless, it should
> eventually get less limited, but that's _eventually_, with a target time
> likely still in years, so don't hold your breath.

   hah.

   - Its not that difficult to pick up a suitable sized disk from the
     global hot spare list.
   - A CLI can show which fsid/volume a global hot spare can be the
     candidate for the potential replacement.
   - An auto replace priority can be at the fsid/volume end or we could
     still dedicate a global hot spare device to a fsid/volume.

  Related patches (needs revival):
   btrfs: block incompatible optional features at scan
   btrfs: introduce BTRFS_FEATURE_INCOMPAT_SPARE_DEV
   btrfs: add check not to mount a spare device
   btrfs: support btrfs dev scan for spare device
   btrfs: provide framework to get and put a spare device
   btrfs: introduce helper functions to perform hot replace
   btrfs: check for failed device and hot replace

> I think that answers most of your questions.  Basically, you have to be
> quite careful with btrfs raid1 today, as btrfs simply doesn't have the
> automated functionality to handle it yet.  It's still possible to do two-
> device-only raid1 and replace a failed device when you're down to one,
> but it's not as easy or automated as more mature raid options such as
> mdraid, and you do have to keep on top of it as a result.  But it can and
> does work reasonably well for those (like me) who use btrfs raid1 as
> their "daily driver", as long as you /do/ keep on top of it... and don't
> try to use raid1 as a replacement for real backups, because it's *not* a
> backup! =:^)
> 

Thanks, Anand
