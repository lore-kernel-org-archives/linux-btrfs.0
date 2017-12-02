Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:56662 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751256AbdLBC47 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 1 Dec 2017 21:56:59 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1eKxyz-0001Re-66
        for linux-btrfs@vger.kernel.org; Sat, 02 Dec 2017 03:56:49 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: exclusive subvolume space missing
Date: Sat, 2 Dec 2017 02:56:38 +0000 (UTC)
Message-ID: <pan$b03b8$e13dd242$8f38c9df$c039f238@cox.net>
References: <20171201161555.GA11892@polanet.pl>
        <20171201213614.GE29898@carfax.org.uk> <20171202005338.GA20205@polanet.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Tomasz Pala posted on Sat, 02 Dec 2017 01:53:39 +0100 as excerpted:

> #  btrfs fi usage /
> Overall:
>     Device size:                 128.00GiB
>     Device allocated:            117.19GiB
>     Device unallocated:           10.81GiB
>     Device missing:                  0.00B
>     Used:                        103.56GiB
>     Free (estimated):             11.19GiB      (min: 11.14GiB)
>     Data ratio:                       1.98
>     Metadata ratio:                   2.00
>     Global reserve:              146.08MiB      (used: 0.00B)
> 
> Data,single: Size:1.19GiB, Used:1.18GiB
>    /dev/sda2       1.07GiB
>    /dev/sdb2     132.00MiB
> 
> Data,RAID1: Size:55.97GiB, Used:50.30GiB
>    /dev/sda2      55.97GiB
>    /dev/sdb2      55.97GiB
> 
> Metadata,RAID1: Size:2.00GiB, Used:908.61MiB
>    /dev/sda2       2.00GiB
>    /dev/sdb2       2.00GiB
> 
> System,RAID1: Size:32.00MiB, Used:16.00KiB
>    /dev/sda2      32.00MiB
>    /dev/sdb2      32.00MiB
> 
> Unallocated:
>    /dev/sda2       4.93GiB
>    /dev/sdb2       5.87GiB

OK, is this supposed to be raid1 or single data, because the above shows
metadata as all raid1, while some data is single tho most is raid1, and
while old mkfs used to create unused single chunks on raid1 that had to
be removed manually via balance, those single data chunks aren't unused.

Which means if it's supposed to raid1, you don't have redundancy on that
single data.

Assuming the intent is raid1, I'd recommend doing...

btrfs balance start -dconvert=raid1,soft /

Probably disable quotas at least temporarily while you do so, tho, as
they don't scale well with balance and make it take much longer.

That should go reasonably fast as it's only a bit over 1 GiB on the one
device, and 132 MiB on the other (from your btrfs device usage), and the
soft allows it to skip chunks that don't need conversion.

It should kill those single entries and even up usage on both devices,
along with making the filesystem much more tolerant of loss of one of
the two devices.


Other than that, what we can see from the above is that it's a relatively
small filesystem, 64 GiB each on a pair of devices, raid1 but for the
above.

We also see that the allocated chunks vs. chunk usage isn't /too/ bad,
with that being a somewhat common problem.  However, given the relatively
small 64 GiB per device pair-device raid1 filesystem, there is some
slack, about 5 GiB worth, in that raid1 data, that you can recover.

btrfs balance start -dusage=N /

Where N represents a percentage full, so 0-100.  Normally, smaller
values of N complete much faster, with the most effect if they're
enough, because at say 10% usage, 10 90% empty chunks can be rewritten
into a single 100% full chunk.

The idea is to start with a small N value since it completes fast, and
redo with higher values as necessary to shrink the total data chunk
allocated value toward usage.  I too run relatively small btrfs raid1s
and would suggest trying N=5, 20, 40, 70, until the spread between
used and total is under 2 gigs, under a gig if you want to go that far
(nominal data chunk size is a gig so even a full balance will be unlikely
to get you a spread less than that).  Over 70 likely won't get you much
so isn't worth it.

That should return the excess to unallocated, leaving the filesystem 
able to use the freed space for data or metadata chunks as necessary,
tho you're unlikely to see an increase in available space in (non-btrfs)
df or similar.  If the unallocated value gets down below 1 GiB you may
have issues trying to free space since balance will want space to write
the chunk it's going to write into to free the others, so you probably 
want to keep an eye on this and rebalance if it gets under 2-3 gigs
free space, assuming of course that there's slack between used and
total that /can/ be freed by a rebalance.

FWIW the same can be done with metadata using -musage=, with metadata
chunks being 256 MiB nominal, but keep in mind that global reserve is
allocated from metadata space but doesn't count as used, so you typically
can't get the spread down below half a GiB or so.  And in most cases
it's data chunks that get the big spread, not metadata, so it's much
more common to have to do -d for data than -m for metadata.


All that said, the numbers don't show a runaway spread between total
and used, so while this might help, it's not going to fix the primary
space being eaten problem of the thread, as I had hoped it might.

Additionally, at 2 GiB total per device, metadata chunks aren't runaway
consuming your space either, as I'd suspect they might if the problem were
for instance atime updates, so while noatime is certainly recommended and
might help some, it doesn't appear to be a primary contributor to the
problem either.


The other possibility that comes to mind here has to do with btrfs COW
write patterns...

Suppose you start with a 100 MiB file (I'm adjusting the sizes down from
the GiB+ example typically used due to the filesystem size being small,
64 MiB usable capacity due to raid1).  And for simplicity, suppose it's
allocated as a single 100 MiB extent

Now make various small changes to the file, say under 16 KiB each.  These
will each be COWed elsewhere as one might expect. by default 16 KiB at
a time I believe (might be 4 KiB, as it was back when the default leaf
size was 4 KiB, but I think with the change to 16 KiB leaf sizes by default
it's now 16 KiB).

But here's the kicker.  Even without a snapshot locking that original 100
MiB extent in place, if even one of the original 16 KiB blocks isn't
rewritten, that entire 100 MiB extent will remain locked in place, as the
original 16 KiB blocks that have been changed and thus COWed elsewhere
aren't freed one at a time, the full 100 MiB extent only gets freed, all
at once, once no references to it remain, which means once that last
block of the extent gets rewritten.

So perhaps you have a pattern where files of several MiB get mostly
rewritten, taking more space for the rewrites due to COW, but one or
more blocks remain as originally written, locking the original extent
in place at its full size, thus taking twice the space of the original
file.

Of course worst-case is rewrite the file minus a block, then rewrite
that minus a block, then rewrite... in which case the total space
usage will end up being several times the size of the original file!

Luckily few people have this sort of usage pattern, but if you do...

It would certainly explain the space eating...

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

