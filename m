Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:45920 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752068AbaEFTn2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 6 May 2014 15:43:28 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WhjoZ-0000jL-4B
	for linux-btrfs@vger.kernel.org; Tue, 06 May 2014 20:10:03 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 06 May 2014 20:10:03 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 06 May 2014 20:10:03 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Using mount -o bind vs mount -o subvol=vol
Date: Mon, 5 May 2014 02:12:30 +0000 (UTC)
Message-ID: <pan$422b5$795bfbf0$455b3e56$2333506b@cox.net>
References: <20140504004732.GE9061@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Marc MERLIN posted on Sat, 03 May 2014 17:47:32 -0700 as excerpted:

> Is there any functional difference between
> 
> mount -o subvol=usr /dev/sda1 /usr

> and

> mount /dev/sda1 /mnt/btrfs_pool
> mount -o bind /mnt/btrfs_pool/usr /usr
> 
> ?

Brendan answered the primary aspect of this well so I won't deal
with that.  However, I've some additional (somewhat controversial)
opinion/comments on the topic of subvolumes in general.

TL;DR: Put simply, with certain sometimes major exceptions, IMO subvolumes 
are /mostly/ a solution looking for a problem.  In the /general/ case, I 
don't see the point and personally STRONGLY prefer multiple independent 
partitions for their much stronger data safety and mounting/backup 
flexibility.  That's why I use independent partitions, here.

Relevant points to consider:

Subvolume negatives, independent partition positives:

1) Multiple subvolumes on a common filesystem share the filesystem tree- 
and super-structure.  If something happens to that filesystem, you had 
all your data eggs in that one basket and the bottom just dropped out of 
it!  If you can't recover, kiss **ALL** those data "eggs" goodbye!

That's the important one; the one that would prevent me sleeping well if 
that's the solution I had chosen to use.  But there's a number of others, 
more practical in the binary "it's not an unrecoverable failure" case.

2) Presently, btrfs is rather limited in the opposing mount options it 
can apply to subvolumes on the same overall filesystem.  Mounting just 
one subvolume nodatacow, for instance, without mounting all mounted 
subvolumes of the filesystem nodatacow isn't yet possible, tho the 
filesystem design allows for it and the feature is roadmapped to appear 
sometime in the future.

This means that at present, the subvolumes solution severely limits your 
mount options flexibility, altho that problem should go away to a large 
degree at some rather handwavily defined point in the future.

3) Filesystem size and time to complete whole-filesystem operations such 
as balance, scrub and check are directly related; the larger the 
filesystem, the longer such operations take.  There are reports here of 
balances taking days on multi-terabyte filesystems, and double-digit 
hours isn't unusual at all.

Of course SSDs are generally smaller and (much) faster, but still, a 
filesystem the size of a quarter or a half-gig SSD could easily take an 
hour or more to balance or scrub, and that can still be a big deal.

Contrast that with the /trivial/ balance/scrub times I see on my 
partitioned btrfs-on-ssd setup here, some of them under a minute, even 
the "big" btrfs of 24 GiB (gentoo packages/sources/ccache filesystem) 
taking under three minutes (just under 7 second per GiB).  At those times 
the return is fast enough I normally run the thing in foreground and wait 
for it to return in real-time; times trivial enough I can actually do a 
full filesystem rebalance in ordered to time it to make this point on a 
post! =:^)

Of course the other aspect of that is that I can for instance fsck my 
dedicated multimedia filesystem without it interfering with running X and 
my ordinary work on /home.  If it's all the same filesystem and I have to 
fsck from the initramfs or a rescue disk...

Now ask yourself, how likely are you to routinely run a scrub or balance 
as preventive maintenance if you know it's going to take the entire day 
to finish?  Here, the times are literally so trivial can and do run a 
full filesystem rebalance to time it and make this point and maintenance 
such as scrub or balance simply ceases to be an issue.

I actually learned this point back on mdraid, before I switched to 
btrfs.  When I first setup mdraid, I had only three raids, primary/
working, secondary/first-backup, and the raid0 for stuff like package 
cache that I could simply redownload if necessary.  But if a device 
dropped (as it occasionally did after a resume from hibernate, due to 
hardware taking too long to wake up and the kernel giving up on it), the 
rebuild would take HOURS!

Later on, after a few layout changes, I had many more raids and kept some 
of them (like the one containing my distro package cache) deactivated 
unless I actually needed to use them (if I was actually doing an 
update).  Since a good portion of the many more but smaller raids were 
offline most of the time, if a device dropped, I had far fewer and 
smaller raids to rebuild, and was typically back up and running in under 
a half hour.

Filesystem maintenance time DOES make a difference!

Subvolume positives, independent partition negatives:

4) Many distros are using btrfs subvolumes on a single btrfs "storage 
pool" the way they formerly used LVM volume groups, as a common storage 
pool allowing them the flexibility to (re)allocate space to whatever lvm 
volume or btrfs subvolume needs it.

This is a "killer feature" from the viewpoint of many distros and users 
as the flexibility means no more hassle with guessing incorrectly which 
volume is going to grow the most and therefore need more space, when it 
doesn't HAVE any more space, resulting in a maze of mountpoints/symlinks/
bind-mounts to maintain as new independent filesystems are added and 
mounted/symlinked into the tree in whatever hacked up method suits the 
moment.

OTOH, for users and distros with a pretty good idea of what their 
allocations are going to look like, generally due to the experience 
they've gained over the years, that extra flexibility isn't a big benefit 
anyway, certainly not when compared against its cost in terms of the 
first three points.  In particular, for this relatively experienced user 
with a good notion of a partitioning layout that works for me, along with 
the required sizes of each partition, the risks of point #1 above far FAR 
outweigh the relatively small benefit the additional flexibility of a 
single btrfs "storage pool" would give me.

5) The fact that subvolumes appear as directories can make them easier to 
deal with, and can mean that with an appropriately laid out tree, 
actually mounting the subvolumes becomes rather optional, since they'll 
appear in the appropriate spot once the parent subvolume is mounted 
anyway.

6) Subvolumes be used to control snapshotting since snapshots stop at 
subvolume boundaries.  In the presence of point #5 "storage pools", and 
given the reality of btrfs NOCOW attribute behavior when mixed with 
snapshots, subvolumes become an important tool for limiting snapshot 
coverage area, in particular, for demarcing areas that should NOT be 
snapshotted when the filesystem or parent subvolume is snapshotted, due 
for instance to the horrible interaction between large heavy-internal-
rewrite files and COW, which means they should be set NOCOW, coupled with 
the horrible interaction between NOCOW on such files and snapshotting.

Similarly, subvolumes and their boundaries can be used to set borders for 
frequency or timing of snapshotting, say snapshotting the general
root/system tree before updates, while snapshotting /home hourly.

7) There are of course specific use-cases where the storage pool 
flexibility and lower general hassle level of subvolumes as opposed to 
independent filesystems may be desired.  These will primarily trigger 
when size granularity is on the low end for separate dedicated 
filesystems and where on traditional filesystems a simple subdir would 
likely be used as a full separate partition simply isn't worth the 
hassle, but given that btrfs does have this convenient incremental 
subvolume step between the simple subdir and an entire separate 
filesystem, taking advantage of the option makes sense.

This point is one that I haven't actually seen explored much, as of yet, 
I guess because it's so new and unfamilar, and also because so many at 
the distro level are too busy exploiting subvolumes for point #4 (which I 
argue isn't worth the point #1 risk, so I lean toward the separate 
filesystem option for that one) to even realize subvolumes are available 
for use as this incremental step, as well.

Point #6 is, I'd argue, one of the few "legitimate" use-cases for 
subvolumes as opposed to independent filesystems, and it actually loses 
relevancy if #4 is subsumed to point #1 and #3, already.  However, given 
the reality of popular distro btrfs layouts and usage, #4 is in practice 
overruling all the others in many distro-default btrfs deployments today, 
and #6 then becomes relevant.

And of course point #7 is relevant, but currently mostly unexplored.  I 
think only over time will we see people finding good subvolume usage as 
the incremental between subdir and separate filesystem.  2-5 years out, I 
think we'll see people using point #7 incrementals rather more.  
Certainly, I'm curious what #7 usages I may well discover for my own use. 
=:^)


Back in the context of the original question, now, bottom line, IMO 
subvolumes as they tend to be used today should rather be independent 
filesystems on their own partitions.  Were that the case I think it'd 
spare a lot of the grief people are going to be seeing in the next few 
years as btrfs becomes more popular and as the deployments begin to age, 
exposing these now new or still future filesystems to the ravages of 
chance and time.  Were a majority of these subvolume deployments made as 
independent filesystems, people would still lose some data on the 
filesystems that went bad, but they'd very likely have far less exposure 
then, than they actually will as currently subvolume-deployed, as a 
result of the all-data-eggs-in-one-filesystem-basket accident-waiting-to-
happen.

And when those accidents do happen, more data would either never have 
been at risk in the first place, or would have been more easily recovered 
if it was at risk, if the majority of these subvolumes were separate 
filesystems.

So my vote would be, for example (modified slightly for posting from my 
own mounts):

mount /dev/sda5 /
mount /dev/sda4 /var/log
mount /dev/sda6 /home

... and possibly (since rootfs is read-only mounted by default, here, and 
some of these need to be writable in routine operation)...

mount --bind /home/var/lib /var/lib

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

