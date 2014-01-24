Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:36050 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751686AbaAXGy7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Jan 2014 01:54:59 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1W6afJ-00005m-EA
	for linux-btrfs@vger.kernel.org; Fri, 24 Jan 2014 07:54:57 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 24 Jan 2014 07:54:57 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 24 Jan 2014 07:54:57 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Options for SSD - autodefrag etc?
Date: Fri, 24 Jan 2014 06:54:31 +0000 (UTC)
Message-ID: <pan$3043$d8104a03$9e09c506$6ce38ae5@cox.net>
References: <52E19667.6090005@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

KC posted on Thu, 23 Jan 2014 23:23:35 +0100 as excerpted:

> I was wondering about whether using options like "autodefrag" and
> "inode_cache" on SSDs.
> 
> On one hand, one always hears that defragmentation of SSD is a no-no,
> does that apply to BTRFS's autodefrag?
> Also, just recently, I heard something similar about "inode_cache".
> 
> On the other hand, Arch BTRFS wiki recommends to use both options on
> SSDs  http://wiki.archlinux.org/index.php/Btrfs#Mount_options
> 
> So to clear things up, I ask at the source where people should know
> best.
> 
> Does using those options on SSDs gives any benefits and causes
> non-negligible increase in SSD wear?

inode_cache is not recommended for general use, tho it can make sense for 
use-cases such as busy maildir based email servers where there's a lot of 
small files being constantly written and erased.  Additionally, since 
btrfs is not yet fully stable (tho with kernel 3.13 the kconfig warning 
for btrfs was officially decreased in severity), my thought is if it's 
disabled, that's one less feature I have to worry about bugs in, for my 
filesystems. =:^)  So don't enable inode_cache unless you know you need 
it.

autodefrag is an interesting one, and I asked about it too when I was 
setting up my ssd-backed btrfs filesystems, so good question! =:^)

Yes, autodefrag does use up somewhat limited on SSD write cycles, and 
yes, there's no seek time to worry about on SSDs so fragmentation doesn't 
hurt as badly as it does on spinning rust.

There's still some cost to fragmentation, however -- each file fragment 
is an IOPS count on access, and while modern SSDs are rated pretty high 
IOPS, copy-on-write (COW) based filesystems like btrfs can heavily 
fragment "internally rewritten" (as opposed to written once and never 
changed, or new data always appended at the end like a log file or 
streaming media recording) files.  We've seen worst-cases internal-
rewritten files such as multi-gig VMs reported here, with 100K extents or 
more!  That *WILL* eat up IOPS, even on SSDs, and there's other serious 
issues with that heavily fragmented a file as well, not least the 
additional chance of damage to it given all the work btrfs has to do 
tracking all those extents!  But for that large a file, autodefrag isn't 
really the best option.  See a couple paragraphs down for a better one 
for such large files.

There are several COW-triggered fragmentation worst-cases.  Perhaps the 
most common one on a typical desktop is small database files such as the 
sqlite files used for firefox history, cookies, etc, and this is where 
the autodefrag mount option really shines and what it was designed for.

Larger internal-write files (say half a gig or bigger), particularly 
highly active ones where file updates may come fast enough rewriting the 
whole file slows things down, like big active database files, pre-
allocated bittorrent download files, or multi-gig VM images, are a rather 
different problem, and autodefrag doesn't work as well with them.  For 
these, the NOCOW file attribute (set with chattr +C, see the chattr 
manpage), which with btrfs must be set before data is written into the 
file, works rather better.  The easiest way to set the attribute before 
the file is written into is to set it on the containing directory so new 
files created in it inherit the attribute automatically.  So setup your 
database, VMs, or torrent client to use the same dir for everything, then 
set +C/NOCOW on that dir before the files are downloaded/created/copied-
into-it/whatever.  That way, rewrites happen in-place instead of creating 
a new extent every time some bit of the file changes.

Of course another alternative is to use an entirely separate filesystem 
for your big internal-write files, either something like ext4 that's not 
COW-based, or btrfs with the NODATACOW mount option set (tho you'd 
definitely not want to use that for a general purpose btrfs).

But back to autodefrag. It's also worth noting that actually doing the 
install with this option enabled can make a difference too, as apparently 
a number of popular distro installers trigger fragmentation during their 
work, leaving even brand new installations heavily fragmented if the 
install is to btrfs mounted without autodefrag.

One more note on fragmentation.  filefrag doesn't yet understand btrfs 
compression, and reports each compression block (128 KiB IIRC) as a 
separate extent.  So if you use compression (I use compress=lzo, here), 
don't be surprised to see larger files reported as several hundred 
extents, perhaps a few thousand on gigabyte sized files.  If you're 
worried about it, (manually, btrfs fi defrag) defrag the file and see if 
the number of reported extents goes down significantly.  If it does, the 
file was fragmented and defragmenting helped.  If not, defragmenting 
didn't help.

Anyway, yes, I turned autodefrag on for my SSDs, here, but there are 
arguments to be made in either direction, so I can understand people 
choosing not to do that.

One not-btrfs specific mount option that's very useful for btrfs, 
particularly if you're using btrfs snapshotting features, SSD or not, is 
noatime. While admins have been disabling atime updates for years to get 
better performance and that's recommended in general unless you run mutt 
(with other than mbox files) or something else that requires it, given 
that the exclusive size of a snapshot is the size of the filesystem 
changes written between it and the previous snapshot, with atime updates 
on and not a lot of other writes, those atime updates can be a big part 
of the exclusive size of that snapshot!  So disabling them means smaller 
and more efficient snapshots, particularly if there isn't that much other 
write activity going on either.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

