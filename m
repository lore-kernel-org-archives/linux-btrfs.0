Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:52920 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753128AbaKMHg7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 13 Nov 2014 02:36:59 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Xooxe-0006Cu-17
	for linux-btrfs@vger.kernel.org; Thu, 13 Nov 2014 08:36:58 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 13 Nov 2014 08:36:58 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 13 Nov 2014 08:36:58 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs balance fails with no space errors (despite having
 plenty)
Date: Thu, 13 Nov 2014 07:36:46 +0000 (UTC)
Message-ID: <pan$958d9$17f44acc$12e0a2d6$a6671a4d@cox.net>
References: <E8C63C11EA3FB04DBDFEDECEFD927FD1139F9841@US-EVT-EXM04-P.global.tektronix.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Kline, Matthew posted on Wed, 12 Nov 2014 18:48:47 +0000 as excerpted:

> Hi all,
> 
> Yesterday I converted my ext4 root and home partitions on my home machine
> to btrfs using btrfs-convert. After confirming that everything went well,
> I followed the wiki instructions to nuke the 'ext2_saved" subvolume,
> then defraggad and rebalanced. Everything went according to plan on my root
> partition, but my home partition claimed to have run out of space
> when rebalancing.
> 
> I did some digging and tried the following to resolve the problem,
> but to no avail. So far I have:
> 
> - Made sure I deleted the subvolume (a common cause of this problem).
>   `sudo btrfs subvolume list -a /home` exits with no output.
> 
> - Made sure I defragged the newly converted btrfs partition before
>   attempting to rebalance it.
> 
> - Made sure that I actually have space on the partition.
>   It is only about 60% full - see sdb1 below:
> 
>   ~ % sudo btrfs fi show
>   Label: none  uuid: 3a154348-9bd4-4c3f-aaf8-e9446d3797db
>       Total devices 1 FS bytes used 9.49GiB
>       devid    1 size 87.47GiB used 11.03GiB path /dev/sda3
> 
>   Label: none  uuid: cc90ee50-bbda-46d6-a7e6-fe1c8578d75b
>       Total devices 1 FS bytes used 124.98GiB
>       devid    1 size 200.00GiB used 127.03GiB path /dev/sdb1
> 
> - Made sure I have metadata space (as suggested on the problem FAQ):
> 
>   ~ % sudo btrfs fi df /home
>   Data, single: total=126.00GiB, used=124.58GiB
>   System, single: total=32.00MiB, used=20.00KiB
>   Metadata, single: total=1.00GiB, used=404.27MiB
>   GlobalReserve, single: total=136.00MiB, used=0.00B
> 
> - Ran partial rebalances using the `-dusage` flag
>   (as suggested on the problem FAQ),
>   which successfully balanced a handful of blocks.
> 
> - Checked the system log - nothing interesting comes up.
>   btrfs happily chugs along with "found xxx extents" and
>   "relocating block group xxxxx flags 1" messages before unceremoniously
>   ending with "7 enospc errors during balance".
> 
> In spite of all of this, a full rebalance still fails when it's about
> 95% done.  I'm at a complete loss as to what could be causing it - I know
> that it's not completely necessary (especially with a single drive),
> and `btrfs scrub` finds no errors with the file system,
> but the wiki gives the impression that it's a good idea after you
> convert from ext.
> 
> Is there something I'm missing?
> 
> Best,
> Matt Kline
> 
> Other obligatory info: I'm on Arch Linux using btrfs 3.17.1. uname -a is
> 
> Linux kline-arch 3.17.2-1-ARCH #1 SMP PREEMPT
> Thu Oct 30 20:49:39 CET 2014 x86_64 GNU/Linux

Hmm...  You've jumped thru all the conversion hoops, including deleting
the old ext4 saved subvolume, and a defrag after, and it's still not
working.  You're absolutely right that a balance is a good idea at this
point, because once it completes successfully, you know everything made
it thru successfully into native btrfs format, so that a balance is
failing is a good hint that /something/ didn't get fully converted to
native btrfs format yet, despite all those hoops.

I'd guess something went wrong with the defrag.  Here's the deal with it.
Hope you don't have too many files over a GiB (but have at least one,
or the problem must be something else)...

Ext3/4 filesystems can have extents far larger than those on native
btrfs, which are limited to the 1 GiB data-chunk size.  What the initial
btrfs conversion does is simply create btrfs metadata pointing at the
existing ext3/4 data, placing the new btrfs metadata chunks (which are
a quarter GiB in size) in what was the free space on the ext* fs.  The
ext* metadata remains in place, along with the data with both the ext*
and the btrfs metadata pointed at it.  The ext* data and metadata
together form the ext2_saved subvolume, and because btrfs is
copy-on-write, aka COW, any changes made to the data on the btrfs side
are automatically written elsewhere, leaving the existing data (and
ext* metadata) untouched in the ext2_saved subvolume.

So as it is when converted, data extents can still be far larger than
the btrfs-native 1 GiB data extent, and balance can't deal with that.

After the ext2_saved subvolume is removed and there's no going back
to the ext*, it's safe to break up those > 1 GiB non-native-btrfs
data extents, and that's what the defrag is SUPPOSED to do.  Btrfs
defrag rewrites files, normally combining smaller extents into larger
ones upto the 1 GiB data-chunk size, but in this case, it also splits
apart these non-native > 1 GiB super-extents, rewriting them into
native btrfs chunks.

There is, however, a catch.  At one point btrfs defrag was
snapshot aware, but the algorithm used for it matched against
that used for quotas and for snapshots proved unable to scale.
So the snapshot awareness has been disabled again for a few kernel
cycles now, while they rewrite various btrfs internals to scale
better.

So ideally, you'd have no snapshots and no subvolumes when
you did that first defrag.  You mentioned deleting subvolumes
and presumably you deleted snapshots (which are subvolume
special-case) if any as well.

But, did you do that defrag when they were still there?
If so, that /might/ be the problem.

It's also possible there's some other bug in defrag
ATM, and for whatever reason it failed to rewrite some of
those super-extents.

Either way, assuming it's the super-extent problem which I
think it is, other than trying a defrag again, one way to
for sure solve that problem is to make a list of all your
over 1 GiB files, and move them out of the filesystem and
then back in, so they get recreated in native btrfs format.
You can use a find with file-size, or a du -ah piped to
sort -h, or something like filelight, to find the > 1 GiB
files.  Just be sure to get all of them on the filesystem,
because of course if you miss one, that's going to be the
one that was triggering the problem. =:^\

If you have more spare memory than the largest of
these files, probably the fastest way to do this is to
copy them one or a few at a time, to fill memory, into
a tmpfs.  Since tmpfs is memory, unless you go into swap
this should be quite fast.

Then move them back, either to a different filename or
to a different subdir.  Once they are moved back, sync
or btrfs filesystem sync that filesystem, then delete
the old copy from the filesystem.  Doing it this way you
are sure to get rid of the old copy, creating a new
native btrfs copy, but by syncing after the new one
is there before you actually delete the old one, you
should stay safe in case the power goes out at the wrong
time and you lose the content of the tmpfs, because
you will not have actually deleted the old file until
the new one is safely written and you've synced.

Of course when you are done you can move the files back
to their original names/locations.

Another alternative, of course, would be to use either
the other btrfs (root, since it's /home with the problem,
assuming it's large enough), or a thumb-drive large enough
to hold the files.  This will probably take longer than
copies to and from memory, but if memory is too small,
or you have enough room on root or the thumb-drive to
copy everything over at once and you don't have memory
for that, it's a reasonable alternative.


If moving all > 1 GiB files off of the filesystem and
then back on, thus recreating them in native btrfs format,
doesn't help, then either you missed one and it's still
triggering the issue, or there's something else going
on.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

