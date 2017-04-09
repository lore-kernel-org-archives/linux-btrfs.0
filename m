Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:54791 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751479AbdDIDOi (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 8 Apr 2017 23:14:38 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1cx3J7-0002qC-QN
        for linux-btrfs@vger.kernel.org; Sun, 09 Apr 2017 05:14:29 +0200
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: About free space fragmentation, metadata write amplification
 and (no)ssd
Date: Sun, 9 Apr 2017 05:14:24 +0200
Message-ID: <20170409051424.28a086cb@jupiter.sol.kaishome.de>
References: <5e11b988-05ea-c468-21ef-589c71058436@mendix.com>
        <22761.23640.216570.125948@tree.ty.sabi.co.uk>
        <e3e2c13c-8f5d-2848-a3f6-759259d84d9d@mendix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Sun, 9 Apr 2017 02:21:19 +0200
schrieb Hans van Kranenburg <hans.van.kranenburg@mendix.com>:

> On 04/08/2017 11:55 PM, Peter Grandi wrote:
> >> [ ... ] This post is way too long [ ... ]  
> > 
> > Many thanks for your report, it is really useful, especially the
> > details.  
> 
> Thanks!
> 
> >> [ ... ] using rsync with --link-dest to btrfs while still
> >> using rsync, but with btrfs subvolumes and snapshots [1]. [
> >> ... ]  Currently there's ~35TiB of data present on the example
> >> filesystem, with a total of just a bit more than 90000
> >> subvolumes, in groups of 32 snapshots per remote host (daily
> >> for 14 days, weekly for 3 months, montly for a year), so
> >> that's about 2800 'groups' of them. Inside are millions and
> >> millions and millions of files. And the best part is... it
> >> just works. [ ... ]  
> > 
> > That kind of arrangement, with a single large pool and very many
> > many files and many subdirectories is a worst case scanario for
> > any filesystem type, so it is amazing-ish that it works well so
> > far, especially with 90,000 subvolumes.  
> 
> Yes, this is one of the reasons for this post. Instead of only hearing
> about problems all day on the mailing list and IRC, we need some more
> reports of success.
> 
> The fundamental functionality of doing the cow snapshots, moo, and the
> related subvolume removal on filesystem trees is so awesome. I have no
> idea how we would have been able to continue this type of backup
> system when btrfs was not available. Hardlinks and rm -rf was a total
> dead end road.

I'm absolutely no expert with arrays of sizes that you use but I also
stopped using the hardlink-and-remove approach: It was slow to manage
(rsync works slow for it, rm works slow for it) and it was error-probe
(due to the nature of hardlinks). I used btrfs with snapshots and rsync
for a while in my personal testbed, and experienced great slowness over
time: rsync started to become slower and slower, full backup took 4
hours with huge %IO usage, maintaining the backup history was also slow
(removing backups took a while), rebalancing was needed due to huge
wasted space. I used rsync with --inplace and --no-whole-file to waste
as few space as possible.

What I first found was an adaptive rebalancer script which I still use
for the main filesystem:

https://www.spinics.net/lists/linux-btrfs/msg52076.html
(thanks to Lionel)

It works pretty well and has no such big IO overhead due to the
adaptive multi-pass approach.

But it still did not help the slowness. I now tested borgbackup for a
while, and it's fast: It does the same job in 30 minutes or less
instead of 4 hours, and it has much better backup density and comes
with easy history maintenance, too. I can now store much more backup
history in the same space. Full restore time is about the same as
copying back with rsync.

For a professional deployment I'm planning to use XFS as the storage
backend and borgbackup as the backup frontend, because my findings
showed that XFS allocation groups are spanning diagonally across the
disk array, that is if you'd use simple JBOD of your iSCSI LUNs, XFS
will spread writes across all the LUNs without you needing to do normal
RAID striping, which should eliminate the need to migrate when adding
more LUNs, and the underlaying storage layer on the NetApp side will
probably already do RAID for redundancy anyways. Just feed more space to
XFS using LVM.

Borgbackup can do everything that btrfs can do for you but is
targetting the job of doing backups only: It can compress, deduplicate,
encrypt and do history thinning. The only downside I found is that only
one backup job at a time can access the backup repository. So you'd
have to use one backup repo per source machine. That way you cannot
benefit from deduplication across multiple sources. But I'm sure NetApp
can do that. OTOH, maybe backup duration drops to a point that you
could serialize the backup of some machines.

> OTOH, what we do with btrfs (taking a bulldozer and drive across all
> the boundaries of sanity according to all recommendations and
> warnings) on this scale of individual remotes is something that the
> NetApp people should totally be jealous of. Backups management
> (manual create, restore etc on top of the nightlies) is self service
> functionality for our customers, and being able to implement the
> magic behind the APIs with just a few commands like a btrfs sub snap
> and some rsync gives the right amount of freedom and flexibility we
> need.

This is something I'm planning here, too: Self-service backups, do a
btrfs snap, but then use borgbackup for archiving purposes.

BTW: I think the 2M size comes from the assumption that SSDs manage
their storage in groups of erase block sizes. The optimization here
would be that btrfs deallocates (and maybe trims) only whole erase
blocks which typically are 2M. This has a performance benefit. But if
your underlying storage layer is RAID anyways, this no longer maps
correctly. So giving "nossd" here would probably be the better decision
right from the start. Or at least you should be able to give the mount
option the amount of stripes your RAID uses so it would align properly
again. XFS has such tuning options which are usually auto-detected if
the storage driver correctly passes those info through.

Btrfs still has a lot of open opportunities here, but currently it's in
the stabilization phase (while still adding new features). I guess it's
probably going a long time until it will be tuned for optimal
performance. Too long to deploy such scenarios as yours today - at
least regarding production usage. Just my two cents.

-- 
Regards,
Kai

Replies to list-only preferred.

