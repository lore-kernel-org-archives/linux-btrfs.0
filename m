Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47092 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1033141AbeBNRIf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Feb 2018 12:08:35 -0500
Subject: Re: Status of FST and mount times
To: "Ellis H. Wilson III" <ellisw@panasas.com>, linux-btrfs@vger.kernel.org
References: <4d705301-c3a1-baaa-3eb8-f7b92f12f505@panasas.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <27ee5e0b-4127-e890-1322-a31bd62e2412@suse.com>
Date: Wed, 14 Feb 2018 19:08:32 +0200
MIME-Version: 1.0
In-Reply-To: <4d705301-c3a1-baaa-3eb8-f7b92f12f505@panasas.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 14.02.2018 18:00, Ellis H. Wilson III wrote:
> Hi again -- back with a few more questions:
> 
> Frame-of-reference here: RAID0.  Around 70TB raw capacity.  No
> compression.  No quotas enabled.  Many (potentially tens to hundreds) of
> subvolumes, each with tens of snapshots.  No control over size or number
> of files, but directory tree (entries per dir and general tree depth)
> can be controlled in case that's helpful).
> 
> 1. I've been reading up about the space cache, and it appears there is a
> v2 of it called the free space tree that is much friendlier to large
> filesystems such as the one I am designing for.  It is listed as OK/OK
> on the wiki status page, but there is a note that btrfs progs treats it
> as read only (i.e., btrfs check repair cannot help me without a full
> space cache rebuild is my biggest concern) and the last status update on
> this I can find was circa fall 2016.  Can anybody give me an updated
> status on this feature?  From what I read, v1 and tens of TB filesystems
> will not play well together, so I'm inclined to dig into this.

V1 for large filesystems is jut awful. Facebook have been experiencing
the pain hence they implemented v2. You can view the spacecache tree as
the complement version of the extent tree. v1 cache is implemented as a
hidden inode and even though writes (aka flushing of the freespace
cache) are metadata they are essentially treated as data. This could
potentially lead to priority inversions if cgroups io controller is
involved.

Furthermore, there is at least 1 known deadlock problem in freespace
cache v1. So yes, if you want to use btrfs ona multi-tb system v2 is
really the way to go.

> 
> 2. There's another thread on-going about mount delays.  I've been
> completely blind to this specific problem until it caught my eye.  Does
> anyone have ballpark estimates for how long very large HDD-based
> filesystems will take to mount?  Yes, I know it will depend on the
> dataset.  I'm looking for O() worst-case approximations for
> enterprise-grade large drives (12/14TB), as I expect it should scale
> with multiple drives so approximating for a single drive should be good
> enough.
> 
> 3. Do long mount delays relate to space_cache v1 vs v2 (I would guess
> no, unless it needed to be regenerated)?

No, the long mount times seems to be due to the fact that in order for a
btrfs filesystem to mount it needs to enumerate its block_groups items
and those are stored in the extent tree, which also holds all of the
information pertaining to allocated extents. So mixing those
data structures in the same tree and the fact that blockgroups are
iterated linearly during mount (check btrfs_read_block_groups) means on
spinning rust with shitty seek times this can take a while.

However, this will really depend on the amount of extents you have and
having taken a look at the thread you referred to it seems there is not
clear-cut reason why mounting is taking so long on that particular
occasion .


> 
> Note that I'm not sensitive to multi-second mount delays.  I am
> sensitive to multi-minute mount delays, hence why I'm bringing this up.
> 
> FWIW: I am currently populating a machine we have with 6TB drives in it
> with real-world home dir data to see if I can replicate the mount issue.
> 
> Thanks,
> 
> ellis
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
