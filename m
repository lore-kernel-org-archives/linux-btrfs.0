From: Duncan <1i5t5.duncan@cox.net>
Subject: btrfs-raid questions I couldn't find an answer to on the wiki
Date: Thu, 26 Jan 2012 15:41:32 +0000 (UTC)
Message-ID: <pan.2012.01.26.15.41.32@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I'm currently researching an upgrade to (raid1-ed) btrfs from mostly 
reiserfs (which I've found quite reliable (even thru a period of bad ram 
and resulting system crashes) since data=ordered went in with 2.6.16 or 
whatever it was.  (Thanks, Chris! =:^)) on multiple md/raid-1s.  I have 
some questions that don't appear to be addressed well on the wiki, yet, 
or where the wiki info might be dated.

Device hardware is 4 now aging 300-gig disks with identical gpt-
partitioning on all four disks, using multiple 4-way md/raid-1s for most 
of the system.  I'm running gentoo/~amd64 with the linus mainline kernel 
from git, kernel generally updated 1-2X/wk except during the merge 
window, so I stay reasonably current.  I have btrfs-progs-9999, aka the 
live-git build, kernel.org mason tree, installed.

The current layout has a total of 16 physical disk partitions on each of 
the four drives, mostly of which are 4-disk md/raid1, but with a couple 
md/raid1s for local cache of redownloadables, etc, thrown in.  Some of 
the mds are further partitioned (mdp), some not.  A couple are only 2-
disk md/raid1 instead of the usual 4-disk.  Most mds have a working and 
backup copy of exactly the same partitioned size, thus explaining the 
multitude of partitions, since most of them come in pairs.  No lvm as I'm 
not running an initrd which meant it couldn't handle root, and I wasn't 
confident in my ability to recover the system in an emergency with lvm 
either, so I was best off without it.

Note that my current plan is to keep the backup sets as reiserfs on md/
raid1 for the time being, probably until btrfs comes out of experimental/
testing or at least until it further stabilizes, so I'm not too worried 
about btrfs as long as it's not going to go scribbling outside the 
partitions established for it.  For the worst-case I have boot-tested 
external-drive backup.

Three questions:

1) My /boot partition and its backup (which I do want to keep separate 
from root) are only 128 MB each.  The wiki recommends 1 gig sizes 
minimum, but there's some indication that's dated info due to mixed data/
metadata mode in recent kernels.

Is a 128 MB btrfs reasonable?  What's the mixed-mode minumum recommended 
and what is overhead going to look like?

2)  The wiki indicates that btrfs-raid1 and raid-10 only mirror data 2-
way, regardless of the number of devices.  On my now aging disks, I 
really do NOT like the idea of only 2-copy redundancy.  I'm far happier 
with the 4-way redundancy, twice for the important stuff since it's in 
both working and backup mds altho they're on the same 4-disk set (tho I 
do have an external drive backup as well, but it's not kept as current).

If true that's a real disappointment, as I was looking forward to btrfs-
raid1 with checksummed integrity management.

Is there really NO way to do more than 2-way btrfs-raid1?  If not, 
presumably layering it on md/raid1 is possible, but is two-way-btrfs-
raid1-on-2-way-md-raid1 or btrfs-on-single-4-way-md-raid1 (presumably 
still-duped btrfs metadata) recommended?  Or perhaps the recommendations 
for performance and reliability differ in that scenario?

3) How does btrfs space overhead (and ENOSPC issues) compare to reiserfs 
with its (default) journal and tail-packing?  My existing filesystems are 
128 MB and 4 GB at the low end, and 90 GB and 16 GB at the high end.  At 
the same size, can I expect to fit more or less data on them?  Do the 
compression options change that by much "IRL"?  Given that I'm using same-
sized partitions for my raid-1s, I guess at least /that/ angle of it's 
covered.

Thanks. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

