Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:49712 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750720AbaEAFd6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 1 May 2014 01:33:58 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Wfjd6-0004H0-NN
	for linux-btrfs@vger.kernel.org; Thu, 01 May 2014 07:33:56 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 01 May 2014 07:33:56 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 01 May 2014 07:33:56 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Help with space
Date: Thu, 1 May 2014 05:33:45 +0000 (UTC)
Message-ID: <pan$e723c$9c5c686c$f2068dd4$dd71b519@cox.net>
References: <CAAmRLYx1L=o7a2PMSAiJbr7qH_JiuYG2-ncHG-mHLyLcM3Z-GQ@mail.gmail.com>
	<20140228103436.2dfd2669@natsu> <2809235.lZD2oazSeA@xev>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Russell Coker posted on Thu, 01 May 2014 11:52:33 +1000 as excerpted:

> I've just been doing some experiments with a failing disk used for
> backups (so I'm not losing any real data here).

=:^)

> The "dup" option for metadata means that the entire filesystem
> structure is intact in spite of having lots of errors (in another
> thread I wrote about getting 50+ correctable errors on metadata while
> doing a backup).

TL;DR: Discustion of btrfs raid1 and n-way-mirroring.  Bonus discussion 
on spinning rust heat-death and death in general modes.

That's why I'm running raid1 for both data and metadata here.  I love 
btrfs' data/metadata checksumming and integrity mechanisms, and having 
that second copy to scrub from in the event of an error on one of them is 
just as important to me as the device-redundancy-and-failure-recovery bit.

I could get the latter on md/raid and did run it for some years, but the 
fact that there's no way to have it do routine read-time parity cross-
check and scrub (or N-way checking and vote, rewriting to a bad copy on 
failure, in the case of raid1), even tho it has all the cross-checksums 
already there and available to do it, but only actually makes /use/ of 
that for recovery if a device fails...

My biggest frustration with btrfs ATM is the lack of "true" raid1, aka 
N-way-mirroring.  Btrfs presently only does pair-mirroring, no matter the 
number of devices in the "raid1".  Checksummed-3-way-redundancy really is 
the sweet spot I'd like to hit, and yes it's on the road map, but this 
thing seems to be taking about as long as Christmas does to a five or six 
year old... which is a pretty apt metaphor of my anticipation and the 
eagerness with which I'll be unwrapping and playing with that present 
once it comes! =:^)

> My experience is that in the vast majority of disk failures that don't
> involve dropping a disk the majority of disk data will still be
> readable.  For example one time I had a workstation running RAID-1 get
> too hot in summer and both disks developed significant numbers of
> errors, enough that it couldn't maintain a Linux Software RAID-1 (disks
> got kicked out all the time).  I wrote a program to read all the data
> from disk 0 and read from disk 1 any blocks that couldn't be read from
> disk 0, the result was that after running e2fsck on the result I didn't
> lose any data.

That's rather similar to an experience of mine.  I'm in Phoenix, AZ, and 
outdoor in-the-shade temps can reach near 50C.  Air-conditioning failure 
with a system left running while I was elsewhere.  I came home the the 
"hot car effect", far hotter inside than out, so likely 55-60C ambient 
air temp, very likely 70+ device temps.  The system was still on but 
"frozen" (broiled?) due to disk head crash and possibly CPU thermal 
shutdown.

Surprisingly, after shutting everything down, getting a new AC, and 
letting the system cool for a few hours, it pretty much all came back to 
life, including the CPU(s) (that was pre-multi-core, but I don't remember 
whether it was my dual socket original Opteron, or pre-dual-socket for me 
as well) which I had feared would be dead.

The disk as well came back, minus the sections that were being accessed 
at the time of the head crash, which I expect were physically grooved.

I only had the one main disk running at the time, but fortunately I had 
partitioned it up and had working and backup partitions for everything 
vital, and of course the backup partitions weren't mounted at the time, 
and they came thru just fine (tho without checksumming so I'll never know 
if there were bit-flips, but I could boot from the backup / and mount the 
other backups, and a working partition or two that weren't hurt, just 
fine.

But I *DID* have quite a time recovering anyway, primarily because my 
rootfs, /usr/ and /var (which had the system's installed package 
database), were three different partitions that ended up being from three 
different backup dates... on gentoo, with its rolling updates!  IIRC I 
had a current /var including the package database, but the package files 
actually on the rootfs and on /usr were from different package versions 
from what the db in /var was tracking, and were different from each other 
as well.  I was still finding stale package remnants nearly two years 
later!

But I continued running that disk for several months until I had some 
money to replace it, then copied the system, by then current again except 
for the occasional stale file, to the new setup.  I always wondered how 
much longer I could have run the heat-tested one, but didn't want to 
trust my luck any further, so retired it.

Which was when I got into md/raid, first mostly raid6, then later redone 
to raid1, once I figured out the fancy dual checksums weren't doing 
anything but slowing me down in normal operations anyway.

And on my new setup, I used a partitioning policy I continue to this day, 
namely, everything that the package manager touches[1] including its 
installed-pkg database on /var goes on rootfs.  With a working rootfs and 
several backups of various ages on various physical devices (that 
filesystem's only 8 gig or so, with only 4 gig or so of data, so I can 
and do now keep multiple alternate rootfs partition backups on multiple 
devices) should I need to use them, that means no matter what age the 
backup I might ultimately end up booting to, the package database it 
contains will remain in sync with the content of the packages it's 
tracking.  No further possibility of database and /var from one backup, 
rootfs from another, and /usr from a third!

Anyway, yes, my experience tracks yours.  Both in that case and when I 
simply run the disks to wear-out (which I sometimes do as a secondary/
backup/low-priority-cache-data device once it starts clicking or 
developing bad sectors or whatever), the devices themselves continue to 
work in general, long after I've begun to see intermittent issues with 
them.

Tho my experience to date has been spinning rust.  My primary workstation 
pair of current primary devices are now SSD (Corsair Neutron 256-gig, NOT 
Neutron GTX), partitioned identically with multiple btrfs partitions, in 
btrfs raid1 mode except for the two separate individual /boots), and I'm 
happy with them so far, but I must admit to being a bit worried about 
their less familiar failure modes.

> So if you have BTRFS configured to "dup" metadata on a RAID-5 array
> (either hardware RAID or Linux Software RAID) then the probability of
> losing metadata would be a lot lower than for a filesystem which doesn't
> do checksums and doesn't duplicate metadata.  To lose metadata you would
> need to have two errors that line up with both copies of the same
> metadata block.

Like I said, btrfs raid1 both data/metadata here, for exactly that 
reason.  But I'd sure like to make it triplet-mirror instead of being 
limited to pair-mirror, again for exactly that reason.  Currently, I 
figure the chance of both copies independently going bad is lower than 
the risk of a bug in still-under-development btrfs making BOTH copies 
equally bad (even if they pass checksum), and I'm choosing to run btrfs 
knowing that tho I keep non-btrfs backups just in case.  But as btrfs 
matures and stabilizes, the chance of a btrfs bug making both copies bad 
goes down, while the chance of the two copies independently going bad at 
the same place remains the same, and as the two chances reverse in 
likelihood, I'd sure like to have that triplet-mirroring available.

Oh well, the day will come, even if I'm a six-year-old waiting for 
Christmas at this point.  =:^\

> One problem with many RAID arrays is that it seems to only be possible
> to remove a disk and generate a replacement from parity.  I'd like to be
> able to read all the data from the old disk which is readable and write
> it to the new disk.  Then use the parity from other disks to recover the
> blocks which weren't readable.  That way if you have errors on two disks
> it won't matter unless they both happen to be on the same stripe.  Given
> that BTRFS RAID-5 isn't usable yet it seems that the only way to get
> this result is to use RAID-Z on ZFS.

=:^(  But at least you're already in December, in terms of your btrfs 
Christmas, while at best I'm still in November, for mine...

---
[1] Everything the package manager touches:  Minus a few write-required 
state files and the like in /var, which are now symlinked to parallels 
in /home/var, since I keep the rootfs read-only mounted by default these 
days, but by the same token, those operational-write-required files can 
go missing or be out of sync without dramatically affecting operation.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

