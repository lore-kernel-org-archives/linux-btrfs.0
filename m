Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:42913 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1750893AbdFPFTM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 16 Jun 2017 01:19:12 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1dLjez-0003O2-4C
        for linux-btrfs@vger.kernel.org; Fri, 16 Jun 2017 07:19:05 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Disk usage is more than double the snapshots exclusive data
Date: Fri, 16 Jun 2017 05:18:59 +0000 (UTC)
Message-ID: <pan$686d5$acda508e$9f0cc619$61e038c5@cox.net>
References: <53ff5efd-74de-2ea5-fd1a-12ca35c550f3@stroebel.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Vianney Stroebel posted on Thu, 15 Jun 2017 11:44:34 +0200 as excerpted:

> On a backup drive for a home computer, disk usage as shown by 'btrfs fi
> show' is more than double the snapshots exclusive data as shown by
> "btrfs qgroup show" (574 GB vs 265 GB).
> 
> I've done a lot of research online and I couldn't find any answer to
> this problem.
> 
> Output of some commands:
> 
> sudo btrfs fi show
> Label: 'btrfs-backup'  uuid: [...]
> 	Total devices 1 FS bytes used 573.89GiB
> 	devid    1 size 698.64GiB used 697.04GiB path /dev/sdb1
> 
> btrfs fi df /mnt/btrfs-backup
> Data, single: total=670.01GiB, used=564.26GiB
> System, DUP: total=8.00MiB, used=112.00KiB
> System, single: total=4.00MiB, used=0.00B
> Metadata, DUP: total=13.50GiB, used=8.64GiB
> Metadata, single: total=8.00MiB, used=0.00B
> GlobalReserve, single: total=512.00MiB, used=14.95MiB

[Summary of quote-omitted: kernel 4.10.0 ubuntu, progs 4.9.1, subvolume 
total exclusive 265.23GB]

Five points to make here, two explaining the data that you may be 
misunderstanding, and three recommendations.

But first a disclaimer.  Note that I'm a btrfs user and list regular, but 
not a dev.  So if a btrfs dev says different, go with what they say, not 
what I say.  Also, my particular use-case doesn't use either quotas or 
snapshots, so no personal experience with them, with my knowledge there 
being from the list.  But this is list-common knowledge, and my reply 
will mean others don't have to.

The recommendations:

1) Try: btrfs balance start -dusage=0 -musage=0 /mnt/btrfs-backup

That should quickly get rid of the unused single-mode system and metadata 
chunks, which are an artifact from the way older mkfs.btrfs created the 
filesystem.  Newer mkfs.btrfs doesn't create them any more, but you still 
have to remove the ones created by old mkfs.btrfs with a manual balance.

It might or might not free up additional space from the used single data 
and dup metadata chunks as well.

2) See that devid line under btrfs fi show?  That displays how much space 
is actually allocated (see explanation points for discussion), and by 
subtraction, what remains unallocated, on the filesystem.

You only have about a gig and a half actually unallocated, which is 
alarmingly small.  You really want a few GiB unallocated, at least, in 
ordered to allow btrfs balance, should you need to run it, to do its 
thing.

And actually, btrfs global reserve (which is part of metadata, so 
metadata used will never show zero because the global reserve comes from 
it too) is normally not used at all -- that the reported usage there 
isn't zero indicates that btrfs DID run out of normal space at one point 
and had to use its reserves!  That demonstrates the severity of your 
situation!

You're going to need to try to reduce unused allocations.  I'll explain 
how it works in the explanation below, but here's what you're going to 
try to do (N being a percentage, so 0-100):

btrfs balance start -musage=N /mnt/btrfs-backup

btrfs balance start -dusage=N /mnt/btrfs-backup

You'll need to start small, say with 10 in place of the N.  That says 
only try to balance chunks 10% or less full.  The rebalance process 
rewrites chunks, combining partially full ones in the process, so with 
usage=10, if there's any chunks with that little usage to balance, the 
balance will create one new one to write into, and should be able to fit 
at least 10 old ones, 10% full or less, into it.  So you'll free 9 of the 
10. =:^)

Your goal will be at least 10 GiB unallocated before you stop.  Given a 
filesystem size of 698.64 GiB, that means you'll want to try to get the 
devid line usage below 688 GiB.

But of course you may not have that many that are only 10% full, so you 
may have to go higher to free enough space.  Try 20, 30, 50...  Above 50% 
however, things will slow down as 50% full means you rewrite two to 
recover one, 67% means rewriting three to recover one, etc.  And the 
fuller they are the longer they will take to write!  So if you get what 
you need with 10, great, but you may have to go higher and take longer to 
rewrite it all, and once you hit 67%, you'll be taking long enough to 
write and getting little enough back, that it's probably not worth even 
trying anything higher.

If at any point you get an error saying there wasn't enough space, you'll 
need to try something lower.  If usage=10 fails, try usage=5, down to 
usage=1 if necessary.  Then try increasing it again, say 1, 2, 5...  The 
more space you get unallocated, the easier it'll be, until at several 
gigs, you shouldn't have to worry about running out of space any more.  
That's why I recommended a goal of at least 10 GiB unallocated.

If you don't get much beyond those unused single metadata and system 
chunks returned by balance with usage=0, and balance with usage=1 returns 
an error when tried with either metadata (-m) or data (-d), and/or 
usage=1 goes fine but increasing usage= you still get an ENOSPC before 
you free at least 10 GiB into unallocated, then you're in a bind.  See 
below for the explanation, and there are ways out of the bind, but let's 
cross that bridge if we come to it.

3) Consider whether you really need quotas and turn the feature off if 
you don't /really/ need it.  Yes, that's what gives you the exclusive 
usage numbers and those do have some value (tho they don't mean what you 
apparently think they mean, see the explanation below), but the quota 
feature scales really badly on btrfs, and maintenance commands such as 
btrfs balance and btrfs check take much longer with the quota feature 
enabled than they do if it's disabled.

Additionally, the btrfs quota feature is still immature, and at least 
until quite recently, somewhat buggy, so it couldn't be entirely relied 
on in any case.  With the latest 4.11 kernel, at least some of those 
issues are fixed, but given the quota feature's long-buggy history, I'd 
not trust it for several kernel releases without serious reported bugs, 
so even if they're all fixed at this point, I'd not consider it reliable 
yet.

Given that quotas have both a known scaling issue that increases 
maintenance times dramatically, and a historic reliability problem with 
stability and reliability not yet demonstrated, most people either find 
they don't need quotas /that/ bad, and can turn them off, or that they 
REALLY need them, and thus need a filesystem more stable and mature than 
btrfs, where the quota feature as well is stable and mature enough to 
actually be relied upon.

Of course if you decide to turn quotas off, doing so before the balances 
recommended in #2 above should make it go faster.  However, turning 
quotas off remains optional, while the balances in #2 above are pretty 
mandatory if you want to continue using the filesystem, so being 
optional, I put this last, even if you'd want to do it first if you /do/ 
decide to turn them off.

OK, the explanation points.

Well, one more quick recommendation, first.  btrfs fi usage is a newer 
command that combines the information from btrfs fi show and btrfs fi df 
in a more user friendly form.  FWIW, there's also btrfs dev usage, that 
has a per-device oriented display format, but btrfs fi usage is the one 
most people use the most, especially for single-device filesystems like 
yours.

But the older btrfs fi show and btrfs fi df together, have (almost) the 
same information as btrfs fi usage.  You just have to do a bit more math 
to get some of the numbers.

Anyway, as you're reading thru this explanation, take a look at btrfs fi 
usage as well.  The numbers may be displayed in a way that makes more 
sense there, tho of course I'll be using the ones you posted, from the 
show and (btrfs) df output.

So...

4 (expl-1)) Note from the df (and usage) output, data, single, 670 total, 
564+ used.  Where are the other ~100+ GiB?

Similarly, metadata, dup, total 13.5 GiB, used 8.64 GiB, plus the half a 
gig of global reserve, so say 9-9.5 gig used.  But that's still 4+ GiB 
"missing".

The answer here is in the fact that btrfs uses two-stage allocation.  
First, it allocates chunks, data or metadata (with a special system chunk 
as well, but it doesn't grow like the others and is usually small 
compared to the size of the filesystem).  Then from each chunk, btrfs 
will use space until it runs out, at which point it allocates another 
chunk.

This two-stage allocation into chunks first, then using them, is actually 
a big part of what gives btrfs the flexibility it has, since it's at the 
chunk level that btrfs does dup mode (two copies on a single device, like 
your metadata), single mode (like your data), or the various raid modes 
(raid1 is two copies, allocated on different devices, raid10 is striped 
chunks with two stripes, each one on a different set of devices, raid0 is 
all striped, raid5 and raid6 are striped but with one or two device's 
strips respectively, reserved as parity strips, etc).

And it's at the chunk level that balance actually works, rewriting each 
chunk, one at a time.

So what you are seeing in the above reports is that there's 670 GiB of 
data chunks allocated, but only a bit under 565 GiB of data actually in 
those data chunks, so there's about 105 GiB, so say a bit over 100 GiB, 
of data chunk allocation that's not actually used yet.

Similarly, there's about 4 GiB of unused metadata chunk allocation.

Now data chunks are /nominally/ 1 GiB each (but can be bigger or smaller 
in some cases, thus the "nominally").  Metadata chunks are nominally a 
quarter GiB, aka 256 MiB, each, but dup mode means there's two copies of 
everything, so it's allocated half a gig at a time.

And balance, with the exception of usage=0 mode (because it doesn't 
actually write a new chunk, just erases entirely empty ones), must have 
at least enough space to write that new chunk, before it can erase the 
now empty ones it rewrote into the new one.

Which is why your ~1.5 GiB (btrfs fi show devid line, total minus used, 
or it's actually listed on its own line in btrfs fi usage) of unallocated 
space, is so alarming.

Especially when global reserve is showing non-zero usage, so you had 
apparently used even that unallocated space at one point and had NO 
usable unallocated space, tho usage is apparently down a bit from there, 
giving you the ~1.5 GiB unallocated.

So in /theory/ you /should/ be able to balance with -musage= first, to 
pick up a gig or two a half-gig at a time, then balance with -dusage to 
pick up some more gigs, probably a gig at a time, until you reach at 
least 10 GiB unallocated, but with only ~1.5 GiB unallocated and 
accounting for being into global-reserve usage already does make that a 
bit iffy, and it's quite possible you'll find that say -musage=2 doesn't 
free enough, -musage=3 errors out, and -dusage=1 errors out as well.

But as I said, let's worry about that if we actually find we have to.

Meanwhile, assuming you can get at least 10 GiB unallocated (again, 
either as derived from show's devid line, total minus used, or from the 
unallocated line in usage), you should then be out of the bind and should 
be able to jump immediately to balance -dusage=50 or whatever, to 
hopefully recover most of that 100 GiB to unallocated, that's currently 
stuck in data chunks.

And finally, to actually answer the question you asked...

5 (expl-2)) The sum of the exclusive usages of each subvolume, your 265 
GiB figure, has little to do with total actual usage (except that it 
obviously must be less than or equal to total actual usage), because it 
doesn't account for extents that are referenced from more than one 
subvolume.  Particularly when these subvolumes are snapshots, as seems to 
be the case here, the exclusive value only gives you a number for what is 
NOT shared with other snapshots, basically, a figure indicating what 
actually changed between two snapshots.

This exclusive value is of interest because it's effectively the space 
that you could expect to be freed if you deleted that subvolume/snapshot.

But the exclusive value doesn't include data that didn't change between 
snapshots, that is thus shared between them.  So other than obviously 
being less than the total usage, the sum of exclusives doesn't 
necessarily tell you much about total usage at all.

Of course that's assuming the numbers you are getting are accurate in the 
first place.  As I said, the btrfs quota subsystem has a rather buggy 
history, and while kernel 4.10 or 4.11 should be better than in the past 
as there have been bugfixes recently, there's no guarantee that you're 
not still hitting some other bug in the subsystem that has yet to be 
fixed, so the numbers really can't be relied upon to be accurate in the 
first place.

HTH/Hope that helps explain things and helps get you back on track in 
terms of getting some filesystem unallocated space, as well. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

